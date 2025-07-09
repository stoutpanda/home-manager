{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.browsers.ladybird;
in
{
  options.modules.browsers.ladybird = {
    enable = mkEnableOption "Ladybird browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ladybird
    ];

    # Note: Ladybird is still in early development
    # Extension support and configuration options are limited
    xdg.desktopEntries.ladybird-startup = {
      name = "Ladybird (experimental)";
      genericName = "Web Browser";
      exec = "${pkgs.ladybird}/bin/ladybird";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      comment = "Experimental web browser";
    };
  };
}
