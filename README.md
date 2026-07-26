# feliciterra.com

The public landing site for the Turney Family Network, hosted at [feliciterra.com](https://www.feliciterra.com).

Built with [Zola](https://www.getzola.org/) and [Tailwind CSS v4](https://tailwindcss.com/).

## Prerequisites

- **Node.js** 24.14+ (or use [mise](https://mise.jdx.dev/) — see `.mise.toml`)
- **Zola** — see installation options below

## Build

The build is a two-step process: compile the CSS, then build the site.

### 1. Install dependencies

```sh
npm ci
```

### 2. Build CSS

```sh
npm run build:css         # unminified (development)
npm run build:css:minify  # minified (production)
```

### 3. Build the site

```sh
zola build
```

Output is written to `public/`.

## Development

To serve the site locally with live reload:

```sh
npm run build:css:watch &   # watch Tailwind in the background
zola serve                  # serve at http://127.0.0.1:1111
```

## Nix

A `flake.nix` is included that provides Zola via a dev shell. With [Nix](https://nixos.org/) installed and flakes enabled:

```sh
nix develop          # enter a shell with zola available
```

Or run Zola directly without entering the shell:

```sh
nix develop --command zola build
nix develop --command zola serve
```

## Linting and formatting

```sh
npm run format      # check formatting (oxfmt)
npm run lint:css    # lint CSS (stylelint)
```

## CI / Deployment

GitHub Actions workflows handle CI and deployment automatically:

- **CI** (`ci.yml`) — runs on every PR to `main`: lints and builds the site.
- **Release** (`release.yml`) — runs on every push to `main`: uses [Changesets](https://github.com/changesets/changesets) to open a version PR or publish a new tag.
- **Deploy** (`deploy.yml`) — triggered on version tags or by the release workflow: builds the site and syncs `public/` to a self-hosted [Garage](https://garagehq.deuxfleurs.fr/) S3 bucket via `aws s3 sync`.

See `.env.example` for the required deployment secrets.
