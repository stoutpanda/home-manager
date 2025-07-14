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
}
