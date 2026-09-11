# doteditorconfig

[![Built with devenv](https://devenv.sh/assets/devenv-badge.svg)](https://devenv.sh)
![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/kvazzie/doteditorconfig?utm_source=oss&utm_medium=github&utm_campaign=kvazzie%2Fdoteditorconfig&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)

A Devenv-first tooling base for new repositories. It provides one pinned
environment, one command namespace, formatting, linting, tests, Git hooks, and
CI without requiring a language-specific workspace manager.

The template is monorepo-ready, but it does not create application or package
directories. Add repository components when their purpose and stack are known.

## What is inside

```text
.
├── .editorconfig
├── .envrc
├── .github/workflows/ci.yml
├── .helix/languages.toml
├── AGENTS.md
├── CLAUDE.md -> AGENTS.md
├── devenv.lock
├── devenv.nix
├── devenv.yaml
└── devenv/
    ├── core.nix
    ├── quality.nix
    └── tasks.nix
```

`devenv.nix` is a small import list. The modules under `devenv/` separate the
base environment, repository quality rules, and public commands. A generated
project can add more modules there without turning the root configuration into
one large file.

`devenv.lock` is the only dependency lock for the tooling environment. Commit
it and update it intentionally with `devenv update`.

## Requirements

- Nix
- Devenv 2.1 or newer
- direnv, if automatic shell activation is wanted

There is no flake fallback. Install Devenv before entering the repository.

## Start a repository

Copy the template into an empty repository or use it as the base of a new one:

```bash
git clone --depth 1 https://github.com/kvazzie/doteditorconfig.git my-project
cd my-project
git remote remove origin
direnv allow
```

Without direnv, prefix commands with `devenv shell` or use Devenv tasks
directly.

## Repository commands

Inside the activated shell, run the namespaced scripts:

```bash
repo:fmt
repo:lint
repo:test
```

The same interface is available without shell activation:

```bash
devenv tasks run repo:fmt
devenv tasks run repo:lint
devenv tasks run repo:test
```

`devenv test` is the complete validation command used by CI. It builds the
environment, runs every enabled Git hook against the repository, and runs all
tasks connected to `repo:test`.

`repo:test` starts as a successful no-op because this template does not assume
a test framework. Components add their own test tasks to its dependency graph.

## Extend the task graph

Give each component a namespace and connect its tasks to the repository tasks.
For example, a component module can contain:

```nix
{ config, ... }:

{
  tasks."component:lint" = {
    cwd = "${config.git.root}/path/to/component";
    exec = "component-linter";
    before = [ "repo:lint" ];
  };

  tasks."component:test" = {
    cwd = "${config.git.root}/path/to/component";
    exec = "component-test-runner";
    before = [ "repo:test" ];
  };
}
```

Import that module from `devenv.nix`. The root commands remain unchanged as the
repository grows. Devenv can execute independent tasks concurrently.

## Formatting and linting ownership

`.editorconfig` owns encoding, line endings, final newlines, and trailing
whitespace. It specifies indentation only for formats with a clear convention.
`editorconfig-checker` validates those rules without rewriting files.

Treefmt owns language formatting. Nix uses `nixfmt`, shell files use `shfmt`,
and future components add their formatters to `devenv/quality.nix` or another
imported module. Entering the shell does not format files. Formatting happens
only through `repo:fmt` or the treefmt Git hook.

The default hooks also check JSON, YAML, merge-conflict markers, large files,
dead Nix code, and Statix findings. Devenv installs and runs the hook runner, so
contributors do not install or configure it separately.

## Helix

`.helix/languages.toml` contains repository-level language settings only. Nix
formatting uses the same `nixfmt` binary supplied by Devenv. Personal themes,
keybindings, and editor preferences remain in the user's Helix configuration.

## CI

The GitHub Actions workflow only installs Nix and Devenv, then runs:

```bash
devenv test
```

All project-specific checks stay in the Devenv task graph rather than being
duplicated in CI YAML.

## License

MIT. Use and adapt the template freely.
