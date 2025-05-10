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
- `plugin-slug` (string): Passed value from the input provided

### Test?

Check out [`.local`](./.local) to try it on your local machine.

## Examples

Ready-to-use workflows to get started:

- [Pre-Release](./examples/pre-release.yml)

  - Triggered by a push to a specific branch where the next version is being prepared, then attaches an archived copy as an artifact for manual testing.

- [Release](./examples/release.yml)

  - Triggered by a `vX.X.X` tag push and commits the changes to `WordPress.org`, then creates a GitHub release with the plugin zip file as an asset.
