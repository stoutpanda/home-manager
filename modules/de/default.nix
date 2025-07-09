{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.my.desktop;
in
{
  imports = [
    ./ghostty.nix
    ./bitwarden.nix
    ./browsers/default.nix
  ];

  options.my.desktop = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable desktop environment features and GUI applications";
    };
  };
}
