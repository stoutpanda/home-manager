{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.browsers.chromium;
in
{
  options.modules.browsers.chromium = {
    enable = mkEnableOption "Chromium browser";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      catppuccin.enable = true;
      # Extensions from Chrome Web Store
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      ];

      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--password-store=basic"
        "--disable-features=PasswordManagerOnboarding"
      ];
    };

    # Create a desktop file that opens with startup pages
    xdg.desktopEntries.chromium-startup = {
      name = "Chromium (with startup pages)";
      genericName = "Web Browser";
      exec = "${pkgs.chromium}/bin/chromium --new-window https://boardgamearena.com https://github.com https://news.ycombinator.com https://claude.ai";
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
  };
}
