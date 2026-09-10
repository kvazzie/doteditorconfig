# doteditorconfig

[![Built with devenv](https://devenv.sh/assets/devenv-badge.svg)](https://devenv.sh)
![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/kvazzie/doteditorconfig?utm_source=oss&utm_medium=github&utm_campaign=kvazzie%2Fdoteditorconfig&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)

Batteries-included base tooling for new (especially experimental) repos. Stop copy-pasting `.editorconfig` / `devenv` / `direnv` / `git-hooks` boilerplate.

Clone once, `git subtree` (or just `cp`) into new projects.

## What's inside

```
.
├── .editorconfig          # root = true, tab/2, lf, utf-8, trimmed (md + bat exceptions)
├── .envrc                 # direnv + devenv entrypoint (copy to repo root)
├── flake.nix              # devenv flake shell
├── flake.lock             # pinned inputs (keep committed)
├── devenv.nix             # languages + git-hooks + enterShell
├── devenv.yaml            # inputs (nixpkgs rolling)
├── .helix/
│   └── languages.toml     # repo-level Helix languages (project LSP/formatters only, no personal config)
└── README.md
```

## Quick start in a new repo

### Option A: git subtree (keeps update path)

```bash
# from your new repo
git remote add doteditorconfig git@github.com:artemi1/doteditorconfig.git
git fetch doteditorconfig
git subtree add --prefix=.tooling doteditorconfig main --squash
# then copy what you need to root:
cp .tooling/.editorconfig ./
cp .tooling/.envrc ./
cp .tooling/{flake.nix,flake.lock,devenv.nix,devenv.yaml} ./
cp -r .tooling/.helix ./
direnv allow
devenv shell  # or just enter the dir
```

To pull updates later:
```bash
git subtree pull --prefix=.tooling doteditorconfig main --squash
```

### Option B: sparse copy (no history)

```bash
npx degit artemi1/doteditorconfig#main -- .tooling
# or
git clone --depth 1 git@github.com:artemi1/doteditorconfig.git /tmp/doteditorconfig
cp /tmp/doteditorconfig/.editorconfig ./
cp /tmp/doteditorconfig/.envrc ./
cp /tmp/doteditorconfig/{flake.nix,flake.lock,devenv.nix,devenv.yaml} ./
cp -r /tmp/doteditorconfig/.helix ./
```

### Option C: gist-style (single file)

Each file is standalone — just `curl -O` the raw file.

## devenv + direnv

Prereqs: `nix` with flakes enabled + `direnv` + `nix-direnv`.

```bash
cp .envrc .envrc          # from this repo to new repo root
cp {flake.nix,flake.lock,devenv.nix,devenv.yaml} ./
direnv allow
# devenv will install git-hooks on first enter
```

`devenv.nix` declares basic hooks (`trim-trailing-whitespace`, `end-of-file-fixer`, `editorconfig-checker`, `check-merge-conflicts`). Enable per-project hooks there (e.g. `nixpkgs-fmt`, `shellcheck`, `statix`).

`nixpkgs-fmt` is enabled in `devenv.nix` git-hooks, so it is what CI enforces; `statix` and `deadnix` are present but opt-in (`enable = false` — flip per project). `.helix/languages.toml` points at the same toolchain (`nixpkgs-fmt`, `nixd`), so local editing matches CI.

Hooks are installed via `devenv`'s `git-hooks` module — no manual `.git/hooks` copying needed. `devenv shell` / `direnv` handles it.

## Helix

This template is not an opinionated Helix distribution: no `config.toml` (theme, keys, editor prefs live in `~/.config/helix/`). The repo defines only `.helix/languages.toml` — project-specific LSP/formatters needed to work on *this* project. The Nix section there mirrors the devenv/CI toolchain (`nixpkgs-fmt` formatter, `nixd` language server from `languages.nix.enable`), so the contributor edits with the same tools CI checks.

Helix loads repo-local config from `./.helix/languages.toml` (since 24.07, workspace config). Copy:

```bash
# from your template checkout into the target repo
mkdir -p .helix
cp /tmp/doteditorconfig/.helix/languages.toml .helix/languages.toml
```

Tweak per-project. See `.helix/languages.toml:1`.

## EditorConfig

Already at repo root. No setup. Verifiable via `editorconfig-checker` hook.

## Roadmap

- [x] .editorconfig
- [x] devenv + .envrc + git-hooks
- [x] Helix repo languages (project-only, no personal config.toml)
- [ ] lefthook / pre-commit alternative template
- [ ] justfile / taskfile template
- [ ] CI (github actions) minimal template

## License

MIT — do whatever you want with the templates.
