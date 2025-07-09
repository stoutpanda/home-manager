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
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      enableFishIntegration = true;
      enableBashIntegration = true;
      settings = {
        font-family = "FiraMono";
        font-size = 12;
      };
    };
  };
}
