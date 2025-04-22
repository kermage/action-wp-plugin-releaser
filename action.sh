#!/usr/bin/env bash

set -eu

INPUT_SLUG="${INPUT_SLUG:-${GITHUB_REPOSITORY#*/}}"
INPUT_ASSETS="${INPUT_ASSETS:-.wporg}"
INPUT_DRYRUN="${INPUT_DRYRUN:-false}"
VERSION="${GITHUB_REF_NAME}"
[[ "$VERSION" =~ ^v[0-9] ]] && VERSION="${VERSION#v}"
SVN_URL="https://plugins.svn.wordpress.org/${INPUT_SLUG}"
TAG_URL="${SVN_URL}/tags/${VERSION}"
SVN_DIR="${RUNNER_TEMP}/${INPUT_SLUG}-svn"
EXPORT_DIR="${RUNNER_TEMP}/${INPUT_SLUG}-export"


echo "ℹ︎ DRY RUN: $INPUT_DRYRUN"
echo "ℹ︎ SLUG:    $INPUT_SLUG"
echo "ℹ︎ ASSETS:  $INPUT_ASSETS"
echo "ℹ︎ VERSION: $VERSION"
echo ""

[[ -z "$GITHUB_REF_TYPE" ]] && echo "✕ Invalid trigger! Only branch or tag." && exit 1
[[ -z "$WPORG_USERNAME" ]] && echo "✕ WPORG_USERNAME variable is required." && exit 1
[[ -z "$WPORG_PASSWORD" ]] && echo "✕ WPORG_PASSWORD variable is required." && exit 1


if ! curl -fsSL --head "$SVN_URL" > /dev/null 2>&1; then
	echo "✕ Invalid plugin!"
	exit 1
fi

if curl -fsSL --head "$TAG_URL" > /dev/null 2>&1; then
	echo "✕ Already released!"
	exit 1
fi


echo "➤ Checking out repository..."
svn checkout --depth immediates "$SVN_URL" "$SVN_DIR"
echo ""
echo -n "➤ "
svn update --set-depth infinity "${SVN_DIR}/assets"
echo ""
echo -n "➤ "
svn update --set-depth infinity "${SVN_DIR}/trunk"
echo ""


echo "➤ Setting up workspace..."
git config safe.directory "$GITHUB_WORKSPACE"
git config user.email "$GITHUB_ACTOR"
git config user.name "$GITHUB_ACTOR"

if [[ -n "$(git status --porcelain)" ]]; then
	git add .
	git commit -m "From previous step:"
fi

mkdir -p "$EXPORT_DIR"
git archive HEAD | tar -xC "$EXPORT_DIR"
rsync -rcz "${EXPORT_DIR}/" "${SVN_DIR}/trunk/" --delete

if [[ -d "${GITHUB_WORKSPACE}/${INPUT_ASSETS}/" ]]; then
	rsync -rcz "${GITHUB_WORKSPACE}/${INPUT_ASSETS}/" "${SVN_DIR}/assets/" --delete
fi


echo ""
echo "➤ Preparing the files..."
cd "$SVN_DIR"
svn add . --force > /dev/null
svn status | grep '^\!' | sed 's/! *//' | xargs -I% svn rm %@ > /dev/null
svn cp "trunk" "tags/${VERSION}"

if [[ -d "assets" ]]; then
	file_types=("png" "jpg" "gif" "svg")
	mime_types=("image/png" "image/jpeg" "image/gif" "image/svg+xml")

	for i in "${!file_types[@]}"; do
		if [ -n "$(find "assets" -maxdepth 1 -name "*.${file_types[$i]}" -print -quit)" ]; then
			svn propset svn:mime-type "${mime_types[$i]}" "assets/"*."${file_types[$i]}" || true
		fi
	done
fi


echo ""
echo -n "➤ "
svn update
svn status

if ! $INPUT_DRYRUN; then
	echo ""
	echo "➤ Committing the updates..."

	if ! svn commit -m "Update to version $VERSION" --no-auth-cache --non-interactive  --username "$WPORG_USERNAME" --password "$WPORG_PASSWORD"; then
		exit 1
	fi

	echo "✓ Successfully released!"
fi
