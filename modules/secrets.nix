{ config, inputs, ... }:

{
  # Set up age identities - uses your SSH key to decrypt
  age = {
    # Path to the SSH key used for decryption
    identityPaths = [
      "${config.home.homeDirectory}/.ssh/id_ed25519"
      "${config.home.homeDirectory}/.ssh/id_rsa"
    ];

    # Directory where decrypted secrets will be available at runtime
    secretsDir = "${config.xdg.configHome}/agenix";
    secretsMountPoint = "${config.xdg.configHome}/agenix.d";

    # Define your secrets here
    secrets = {
      # Keep only truly sensitive runtime secrets
      # Example: GitHub token
      # github-token = {
      #   file = ../secrets/github-token.age;
      #   # Optional: set permissions
      #   mode = "600";
      # };

      # Example: SSH private key
      # ssh-key = {
      #   file = ../secrets/ssh-key.age;
      #   path = "${config.home.homeDirectory}/.ssh/id_ed25519_server";
      #   mode = "600";
      # };
    };
  };

  # Install the agenix CLI tool for managing secrets
  home.packages = [ inputs.agenix.packages.x86_64-linux.default ];
}
