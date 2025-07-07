# This file defines who can decrypt secrets
let
  # Your SSH public keys that can decrypt secrets
  jason = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ... your-key-here";  # Replace with your actual public key
  
  # System SSH host keys (if you're also using NixOS)
  # myserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ... host-key-here";
  
  # All users who can decrypt
  users = [ jason ];
  
  # All systems that can decrypt
  systems = [ ];  # Add system keys here if needed
in
{
  # Define which keys can decrypt which secrets
  "github-token.age".publicKeys = users ++ systems;
  "ssh-key.age".publicKeys = users ++ systems;
  # Add more secrets here as needed
}