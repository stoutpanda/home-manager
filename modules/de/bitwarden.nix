{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.desktop;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.bitwarden-desktop
    ];
  };
}
