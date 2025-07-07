# Agenix Quick Start Guide

## Initial Setup

1. **Get your SSH public key:**
   ```bash
   cat ~/.ssh/id_ed25519.pub
   # or
   cat ~/.ssh/id_rsa.pub
   ```

2. **Update secrets/secrets.nix with your public key**

3. **Build to get agenix CLI:**
   ```bash
   home-manager build --flake .#jason
   ```

## Creating Secrets

1. **Create a secret file:**
   ```bash
   echo "ghp_yourGitHubTokenHere" > /tmp/github-token.txt
   ```

2. **Encrypt it with agenix:**
   ```bash
   cd ~/.config/home-manager
   agenix -e secrets/github-token.age < /tmp/github-token.txt
   rm /tmp/github-token.txt  # Clean up!
   ```

3. **Configure in modules/secrets.nix:**
   ```nix
   age.secrets.github-token = {
     file = ../secrets/github-token.age;
   };
   ```

## Using Secrets in Configuration

### Example: Git with encrypted GitHub token
```nix
{ config, ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      github.token = "!cat ${config.age.secrets.github-token.path}";
    };
  };
}
```

### Example: SSH config with encrypted key
```nix
{ config, ... }:
{
  age.secrets.ssh-deploy-key = {
    file = ../secrets/ssh-deploy-key.age;
    path = "${config.home.homeDirectory}/.ssh/deploy_key";
    mode = "600";
  };
  
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "myserver" = {
        identityFile = config.age.secrets.ssh-deploy-key.path;
      };
    };
  };
}
```

## Editing Existing Secrets

```bash
agenix -e secrets/github-token.age
```

## Important Notes

- **Never commit unencrypted secrets!**
- Secrets are decrypted at `home-manager switch` time
- Decrypted secrets live in `~/.config/agenix/` (or your configured path)
- The `.age` files are safe to commit to git
- You need your SSH private key to decrypt

## Troubleshooting

- **"No identity found"**: Make sure your SSH key exists and is listed in `age.identityPaths`
- **"No rule found"**: Update `secrets/secrets.nix` with the secret filename
- **Permission denied**: Check the `mode` setting in your secret configuration