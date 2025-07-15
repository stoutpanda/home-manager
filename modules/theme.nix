{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Global enable for all supported packages
  catppuccin.enable = true;
  # Set the flavor (latte, frappe, macchiato, mocha)
  catppuccin.flavor = "macchiato";

  catppuccin.firefox.profiles = {
    # These need to match the profile names in your firefox.nix
    default = {
      enable = true;
      # These will inherit from global settings if not specified
      # flavor = "macchiato";
      # accent = "mauve";
    };
    dev = {
      enable = true;
    };
  };

}
