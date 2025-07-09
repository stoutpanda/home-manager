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
       inputs.zen-browser.packages."${system}".specific
    ];
  };
}
