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
      pkgs.teamspeak3
      pkgs.discord
      inputs.iamb.packages.${pkgs.system}.default
    ];
  };
}
