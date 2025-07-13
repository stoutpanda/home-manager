{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.modules.browsers.firefox;

  # Common extensions for all profiles
  commonExtensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    bitwarden
    privacy-badger
    vimium
    web-clipper-obsidian
  ];

  # Search engines configuration
  searchEngines = {
    "ddg" = {
      urls = [
        {
          template = "https://duckduckgo.com/?q={searchTerms}";
        }
      ];
      icon = "https://duckduckgo.com/favicon.ico";
      definedAliases = [ "@dd" ];
    };
    "google" = {
      urls = [
        {
          template = "https://www.google.com/search?q={searchTerms}";
        }
      ];
      icon = "https://www.google.com/favicon.ico";
      definedAliases = [ "@g" ];
    };
    "notacc" = {
      urls = [
        {
          template = "https://search.notacc.net/search?q={searchTerms}";
        }
      ];
      definedAliases = [ "@sn" ];
    };
    "noogle" = {
      urls = [
        {
          template = "https://noogle.dev/?search={searchTerms}";
        }
      ];
      definedAliases = [ "@n" ];
    };
  };

  # Pages to open on startup
  startupPages = [
    "https://boardgamearena.com"
    "https://github.com"
    "https://news.ycombinator.com"
    "https://claude.ai"
    "https://boardgamegeek.com"
  ];
in
{
  options.modules.browsers.firefox = {
    enable = mkEnableOption "Firefox browser";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles = {
        default = {
          id = 0;
          name = "Personal";
          isDefault = true;

          extensions = commonExtensions;

          search = {
            default = "ddg";
            engines = searchEngines;
            force = true;
          };

          containers = {
            personal = {
              id = 1;
              name = "Personal";
              icon = "fingerprint";
              color = "yellow";
            };
            social = {
              id = 2;
              name = "Social";
              icon = "fence";
              color = "blue";
            };
            shopping = {
              id = 3;
              name = "Shopping";
              icon = "cart";
              color = "orange";
            };
            banking = {
              id = 4;
              name = "Banking";
              icon = "dollar";
              color = "green";
            };
          };

          settings = {
            # General settings
            "browser.startup.homepage" = lib.concatStringsSep "|" startupPages;
            "browser.startup.page" = 3; # Restore previous session
            "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
            "browser.download.useDownloadDir" = true;

            # Privacy & Security
            "network.trr.mode" = 3; # DNS over HTTPS only
            "network.trr.uri" = "https://cloudflare-dns.com/dns-query";
            "network.trr.custom_uri" = "https://cloudflare-dns.com/dns-query";
            "privacy.donottrackheader.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;

            # Developer tools
            "devtools.enabled" = true;
            "devtools.chrome.enabled" = true;

            # Enable containers
            "privacy.userContext.enabled" = true;
            "privacy.userContext.ui.enabled" = true;

            # Theme - Catppuccin will handle this
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

            # Performance
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.hardware-video-decoding.force-enabled" = true;

            # Disable password saving prompts
            "signon.rememberSignons" = false;
            "signon.autofillForms" = false;
            "signon.generation.enabled" = false;
          };
        };

        dev = {
          id = 1;
          name = "Development";

          extensions = commonExtensions;

          search = {
            default = "ddg";
            engines = searchEngines;
            force = true;
          };

          settings = {
            # Same basic settings as personal profile
            "browser.startup.homepage" = lib.concatStringsSep "|" startupPages;
            "browser.startup.page" = 3;
            "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
            "browser.download.useDownloadDir" = true;

            # Privacy & Security
            "network.trr.mode" = 3;
            "network.trr.uri" = "https://cloudflare-dns.com/dns-query";
            "network.trr.custom_uri" = "https://cloudflare-dns.com/dns-query";

            # Developer tools always enabled
            "devtools.enabled" = true;
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;
            "devtools.theme" = "dark";

            # Disable password saving prompts
            "signon.rememberSignons" = false;
            "signon.autofillForms" = false;
            "signon.generation.enabled" = false;
          };
        };
      };

      # Enable GNOME native messaging host if using GNOME
      enableGnomeExtensions = false;

      # Native messaging hosts for extensions
      nativeMessagingHosts = [ ];
    };
  };
}
