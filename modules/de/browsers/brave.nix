{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.browsers.brave;
in
{
  options.modules.browsers.brave = {
    enable = mkEnableOption "Brave browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
    ];

    # Brave uses the same extension IDs as Chrome
    # Extensions need to be installed manually or via policy
    # Create a desktop file that opens with startup pages
    xdg.desktopEntries.brave-startup = {
      name = "Brave (with startup pages)";
      genericName = "Web Browser";
      exec = "${pkgs.brave}/bin/brave --new-window https://boardgamearena.com https://github.com https://news.ycombinator.com https://claude.ai";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "text/xml"
      ];
    };

    # Brave configuration via command line flags
    home.file.".config/brave-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
      --enable-wayland-ime
      --enable-developer-tools
      --password-store=basic
      --disable-features=PasswordManagerOnboarding
    '';
  };
}
