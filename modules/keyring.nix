{ config, lib, pkgs, ... }:

{
  # User-level GNOME Keyring configuration
  # System-level service and PAM are configured in the NixOS module
  
  # Enable user components for GNOME Keyring
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  # GUI tools for managing keyrings
  home.packages = with pkgs; [
    seahorse  # GUI for managing keyrings
    # Note: gnome-keyring and libgnome-keyring are provided by system
  ];

  # Set up environment variables for keyring
  home.sessionVariables = {
    # Ensure SSH_AUTH_SOCK points to gnome-keyring if not already set
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };
}