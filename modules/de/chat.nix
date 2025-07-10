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
      pkgs.teamspeak3
      pkgs.discord
      config.inputs.iamb.packages.${pkgs.system}.default
    ];
  };
}
