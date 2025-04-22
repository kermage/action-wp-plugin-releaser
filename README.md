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

### Test?

Check [`./local`](./local)
