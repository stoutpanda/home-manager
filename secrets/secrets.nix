# This file defines who can decrypt secrets
let
  # Your SSH public keys that can decrypt secrets
  jason = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPFeXNOR6yaVjRXmu+M2ml2Ex4sA/AoCRa+qLpMJa9w";

  # System SSH host keys (if you're also using NixOS)
  # myserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ... host-key-here";

  # All users who can decrypt
  users = [ jason ];

  # All systems that can decrypt
  systems = [ ]; # Add system keys here if needed
in
{
  # Define which keys can decrypt which secrets
  # Keep only truly sensitive runtime secrets here
  # "github-token.age".publicKeys = users ++ systems;
  # "ssh-key.age".publicKeys = users ++ systems;
}
