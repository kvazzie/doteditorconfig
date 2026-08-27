{ pkgs, lib, config, inputs, ... }:

{
  # Minimal base — enable per-project languages as needed.
  # Example:
  # languages.nix.enable = true;
  # languages.rust.enable = true;
  # languages.python.enable = true;
  # languages.python.venv.enable = true;

  # Keep nix tooling on by default — cheap and useful even in non-nix repos.
  languages.nix.enable = true;

  # Packages available in `devenv shell` (add per-project).
  packages = with pkgs; [
    # editorconfig-checker  # also as git-hook; uncomment if you want CLI
    git
  ];

  # Fast, hermetic git hooks via pre-commit-hooks.nix (managed by devenv).
  # Installed automatically on `direnv allow` / `devenv shell`.
  # Run manually: `pre-commit run --all-files`
  git-hooks.hooks = {
    # --- basics (cheap, always on) ---
    trim-trailing-whitespace.enable = true;
    end-of-file-fixer.enable = true;
    check-merge-conflicts.enable = true;
    check-added-large-files.enable = true;
    check-json.enable = true;
    check-yaml.enable = true;
    editorconfig-checker.enable = true;

    # --- nix (enable if repo has nix) ---
    nixpkgs-fmt.enable = true;
    statix.enable = false;   # set true if you use statix
    deadnix.enable = false;  # set true if you use deadnix

    # --- shell ---
    shellcheck.enable = false; # set true for shell repos
    shfmt.enable = false;

    # --- uncomment per project ---
    # prettier.enable = true;
    # eslint.enable = true;
    # ruff.enable = true;
  };

  # Optional: scripts exposed as `devenv run <name>`
  # scripts.hello.exec = "echo hello from devenv";

  enterShell = ''
    echo "✓ devenv shell (hooks installed)"
    # quick sanity check
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      echo "  (not a git repo — git-hooks will install on first 'git init')"
    fi
  '';

  # https://devenv.sh/tasks/ etc. if needed
}
