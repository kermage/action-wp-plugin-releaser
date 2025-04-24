# Local Action

...with [Docker](https://www.docker.com) engine and [act](https://github.com/nektos/act) CLI tool

## Usage

Build the image

```bash
docker build -t action-wp-plugin-releaser .
```

Prepare variables

```bash
cp .env.example .env
cp .secrets.example .secrets
```

Run the workflow

```bash
act -W 'test.yml'
```

### Simulate

Use `--eventpath=payload.json`

```json
{
	"ref": "refs/tags/1.2.3"
}
```

### Custom

Copy the [`test.yml`](test.yml) file to [.github/workflows/](.github/workflows/).

Modify as needed and simply run with:

```bash
act
```

*Detailed usage at: [act docs](https://github.com/nektos/act)*
