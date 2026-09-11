{ pkgs, ... }:

{
  languages.nix.enable = true;

  packages = [ pkgs.git ];

  enterShell = ''
    echo "devenv shell: repo:fmt, repo:lint, repo:test"
  '';
}
