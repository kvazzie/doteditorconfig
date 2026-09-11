{ config, lib, ... }:

{
  scripts = {
    "repo:fmt" = {
      description = "Format the repository";
      exec = "treefmt";
    };

    "repo:lint" = {
      description = "Run every repository lint hook";
      exec = ''
        ${lib.getExe config.git-hooks.package} run -a \
          -c ${config.git-hooks.configFile}
      '';
    };

    "repo:test" = {
      description = "Run repository tests";
      exec = "true";
    };
  };

  tasks = {
    "repo:fmt" = {
      description = "Format the repository";
      exec = "repo:fmt";
    };

    "repo:lint" = {
      description = "Lint the repository";
      exec = "repo:lint";
    };

    "repo:test" = {
      description = "Run repository tests";
      exec = "repo:test";
      before = [ "devenv:enterTest" ];
    };
  };
}
