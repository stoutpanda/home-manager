{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.modules.browsers;
in
{
  imports = [
    ./firefox.nix
    ./chromium.nix
    ./brave.nix
    ./ladybird.nix
    ./zen-browser.nix
  ];

  options.modules.browsers = {
    enable = mkEnableOption "browser configurations";

    defaultBrowser = mkOption {
      type = types.str;
      default = "firefox";
      description = "Default browser to use";
    };
  };

  config = mkIf cfg.enable {
    # Set default browser
    home.sessionVariables = {
      BROWSER = cfg.defaultBrowser;
      DEFAULT_BROWSER = cfg.defaultBrowser;
    };

    # Enable profile-sync-daemon for faster browser startup
    services.psd = {
      enable = true;
      browsers = [
        "firefox"
        "chromium"
      ];
    };
  };
}
