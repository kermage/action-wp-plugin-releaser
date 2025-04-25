# WordPress Plugin Releaser

> Push a tagged version to the official repository

## Usage

```yaml
- uses: kermage/action-wp-plugin-releaser@latest

  with:
    # Custom plugin slug
    # Default: ${GITHUB_REPOSITORY#*/}
    slug: ''

    # Path to the assets
    # Default: .wporg
    assets: ''

    # Skip actual commit
    # Default: false
    dryrun: ''

  env:
    WPORG_USERNAME: ${{ secrets.WPORG_USERNAME }}
    WPORG_PASSWORD: ${{ secrets.WPORG_PASSWORD }}
```

### Outputs:

- `svn-dir` (string): Path to the SVN directory
- `export-dir` (string): Path to the export directory
- `plugin-zip` (string): Path to the generated plugin zip

### Test?

Check [`./local`](./local)

## Examples

- [Pre-Release](./examples/pre-release.yml)

  - Runs on a specific branch push where the next version is being prepared, then attaches an archived copy as an artifact for manual testing.

- [Release](./examples/release.yml)

  - Runs on a `vX.X.X` tag push and commits the changes to the official repository, then creates a GitHub release with the plugin zip file as an asset.
