# Project workflow

Use Devenv as the entry point for repository tooling:

- `devenv tasks run repo:fmt` formats the repository.
- `devenv tasks run repo:lint` runs every lint hook.
- `devenv tasks run repo:test` runs project tests.
- `devenv test` runs the complete local and CI validation.

Add tools and task implementations as modules under `devenv/`. Namespace
component tasks and connect them to `repo:fmt`, `repo:lint`, or `repo:test`
with Devenv task dependencies. Keep tool versions in `devenv.yaml` or the
Devenv modules.
