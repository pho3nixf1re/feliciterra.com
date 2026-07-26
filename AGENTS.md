@AGENTS.md

# feliciterra.com — Agent & Developer Guide

## What this project is

A **Zola** static site — the public landing page for the Turney Family Network
at [feliciterra.com](https://www.feliciterra.com) and feliciterra.net. The site
is intentionally private: all crawlers are blocked via `robots.txt` and a
`noindex` meta tag in `base.html`. Do not add SEO optimizations, public
analytics, or anything intended to make the site more discoverable.

## Tech stack

| Layer | Tool | Notes |
|---|---|---|
| Static site generator | [Zola](https://www.getzola.org/) | Rust-based; config in `zola.toml` |
| Templating | Tera | Jinja2-like syntax; templates in `templates/` |
| CSS | Tailwind CSS **v4** | Entry point: `src/input.css` |
| CSS typography | `@tailwindcss/typography` | Used for legal page prose |
| Node | 24.14 | Pinned via `mise` (`.mise.toml`) |
| Formatting | `oxfmt` | Not Prettier — run via `npm run format` |
| CSS linting | `stylelint` | Config in `.stylelintrc.json` |
| Versioning | Changesets | Do not manually edit the version in `package.json` |

## Build process

CSS **must** be compiled before Zola runs. Zola does not process CSS — the
`compile_sass = false` setting in `zola.toml` is intentional.

```sh
npm ci                          # install dependencies
npm run build:css               # compile Tailwind → static/style.css
zola build                      # build site → public/
```

`static/style.css` and `public/` are both gitignored build artifacts. Never
commit them.

## Development

```sh
npm run build:css:watch &       # watch Tailwind in the background
zola serve                      # serve with live reload at http://127.0.0.1:1111
```

## Tailwind v4 — important differences from v3

This project uses **Tailwind CSS v4**, which is substantially different from v3:

- Configuration is in `src/input.css` using `@theme`, `@plugin`, and `@source`
  directives — there is no `tailwind.config.js`.
- Use `@import "tailwindcss"` — not `@tailwind base/components/utilities`.
- Custom design tokens are declared with CSS custom properties inside `@theme {}`.
- The stylelint config allowlist includes `plugin, source, theme, utility,
  variant, slot` — these are valid Tailwind v4 at-rules, not errors.

When suggesting CSS changes, use v4 syntax. Do not introduce a
`tailwind.config.js` or v3-style config.

## Theme

The site uses a custom earthy color palette defined in `src/input.css`:

- `terra-*` — warm terracotta tones (primary brand color)
- `forest-*` — muted green accent

Stick to these when adding or changing UI. The full token list is in `src/input.css`.

## Template structure

```
templates/
  base.html    — shared layout (header, footer, stylesheet link)
  index.html   — home page; extends base.html
  page.html    — prose template for legal pages; extends base.html
```

Tera syntax: `{% block name %}`, `{{ variable }}`, `{% extends "base.html" %}`.
Zola-specific globals like `config`, `page`, `get_url()`, and `now()` are
available in templates.

## Content

```
content/
  _index.md           — home page front matter (rendered by index.html)
  privacy-policy.md   — rendered by page.html via Tailwind Typography
  terms-of-service.md — rendered by page.html via Tailwind Typography
```

New pages added to `content/` will automatically use the `page.html` template
unless a different `template` is specified in the front matter.

## External assets

The family monogram image and other media assets are served from
`assets.feliciterra.com`. This CDN is not part of this repository. References
to it come from `config.extra` values in `zola.toml`.

## Nix (optional convenience)

A `flake.nix` is provided for developers who use Nix. It exposes a dev shell
with `zola` available. Nix is **not** a project requirement — Node and Zola can
be installed any other way.

```sh
nix develop                              # enter shell with zola
nix develop --command zola build         # run without entering the shell
```

Even inside the Nix shell, Node and npm must be provided separately (e.g. via
`mise` or system packages). The flake intentionally provides only Zola.

## Versioning and releases

Releases are managed by [Changesets](https://github.com/changesets/changesets).
The workflow is:

1. Add a changeset: `npx changeset`
2. Merge to `main` — the release bot opens a "Version Packages" PR.
3. Merge that PR — the bot tags the release and triggers deployment.

Do not manually edit `version` in `package.json` or create version tags by
hand.

## Deployment

Deployment is fully automated via GitHub Actions. The site is synced to a
self-hosted [Garage](https://garagehq.deuxfleurs.fr/) S3-compatible store using
`aws s3 sync --delete`. Required secrets are documented in `.env.example`.

Never commit secrets or credentials. All deployment configuration belongs in
GitHub Actions secrets under the `Deployment` environment.
