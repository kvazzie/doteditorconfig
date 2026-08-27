# doteditorconfig

Batteries-included base tooling for new (especially experimental) repos. Stop copy-pasting `.editorconfig` / `devenv` / `direnv` / `git-hooks` / Helix boilerplate.

Clone once, `git subtree` (or just `cp`) into new projects.

## What's inside

```
.
├── .editorconfig          # root = true, tab/2, lf, utf-8, trimmed (md + bat exceptions)
├── .envrc                 # direnv + devenv entrypoint (copy to repo root)
├── flake.nix              # devenv flake shell (also mirrored in devenv/flake.nix for subtree)
├── devenv.nix             # languages + git-hooks + enterShell
├── devenv.yaml            # inputs (nixpkgs rolling)
├── devenv/                # mirror for `git subtree --prefix=devenv` usage
│   ├── flake.nix
│   ├── devenv.nix
│   └── devenv.yaml
├── .helix/
│   ├── config.toml        # repo-level Helix editor config
│   └── languages.toml     # repo-level Helix languages config
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
cp -r .tooling/.helix ./
cp -r .tooling/devenv ./  # or just cp .tooling/devenv/* ./ if you keep devenv at root
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
cp -r /tmp/doteditorconfig/.helix ./
cp /tmp/doteditorconfig/devenv/{flake.nix,devenv.nix,devenv.yaml} ./
```

### Option C: gist-style (single file)

Each file is standalone — just `curl -O` the raw file.

## devenv + direnv

Prereqs: `nix` with flakes enabled + `direnv` + `nix-direnv`.

```bash
cp .envrc .envrc          # from this repo to new repo root
cp devenv/flake.nix ./
cp devenv/devenv.nix ./
cp devenv/devenv.yaml ./
direnv allow
# devenv will install git-hooks on first enter
```

`devenv.nix:3` declares basic hooks (`trim-trailing-whitespace`, `end-of-file-fixer`, `editorconfig-checker`, `check-merge-conflicts`). Enable per-project hooks there (e.g. `nixpkgs-fmt`, `shellcheck`, `statix`).

Hooks are installed via `devenv`'s `git-hooks` module — no manual `.git/hooks` copying needed. `devenv shell` / `direnv` handles it.

## Helix

Helix loads repo-local config from `./.helix/config.toml` and `./.helix/languages.toml` (since 24.07, workspace config). Copy:

```bash
mkdir -p .helix
cp .helix/config.toml .helix/config.toml
cp .helix/languages.toml .helix/languages.toml   # optional
```

Tweak per-project. See `.helix/config.toml:1` and `.helix/languages.toml:1`.

## EditorConfig

Already at repo root. No setup. Verifiable via `editorconfig-checker` hook.

## Roadmap

- [x] .editorconfig
- [x] devenv + .envrc + git-hooks
- [x] Helix repo templates
- [ ] lefthook / pre-commit alternative template
- [ ] justfile / taskfile template
- [ ] CI (github actions) minimal template

## License

MIT — do whatever you want with the templates.
