{ lib, ... }:

{
  treefmt = {
    enable = true;
    config.programs = {
      nixfmt.enable = true;
      shfmt.enable = true;
    };
  };

  # Formatting is explicit through repo:fmt. Entering the shell never rewrites files.
  tasks."devenv:treefmt:run".before = lib.mkForce [ ];

  git-hooks.hooks = {
    check-added-large-files.enable = true;
    check-json.enable = true;
    check-merge-conflicts.enable = true;
    check-yaml.enable = true;
    deadnix.enable = true;
    editorconfig-checker.enable = true;
    statix.enable = true;
    treefmt.enable = true;
  };
}
