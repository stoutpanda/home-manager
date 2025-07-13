{ config, lib, pkgs, ... }:

{
  # Enable GNOME Keyring for managing secrets
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  # Ensure gnome-keyring package is installed
  home.packages = with pkgs; [
    gnome-keyring
    libgnome-keyring
    seahorse  # GUI for managing keyrings
  ];

  # Set up environment variables for keyring
  home.sessionVariables = {
    # Ensure SSH_AUTH_SOCK points to gnome-keyring if not already set
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };
}