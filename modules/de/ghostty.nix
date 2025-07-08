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
  config = mkIf cfg.enable {
    home.packages = [
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
