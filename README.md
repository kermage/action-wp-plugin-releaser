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
