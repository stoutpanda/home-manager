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

  # Firefox-specific Catppuccin configuration
  catppuccin.firefox.profiles = {
    # These need to match the profile names in your firefox.nix
    default = {
      enable = true;
      # These will inherit from global settings if not specified
      # flavor = "macchiato";
      # accent = "mauve";
    };
  };

  # Waybar-specific Catppuccin configuration
  # This is needed because Waybar requires explicit CSS styling
  catppuccin.waybar = {
    enable = true;
    # mode can be "prependImport" (default) or "createLink"
    # prependImport adds @import to your existing style
    # createLink creates a symlink to the catppuccin CSS
    mode = "createLink";
  };

}
