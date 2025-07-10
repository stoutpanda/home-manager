# Home Manager Configuration

This repository contains my Nix Home Manager configuration using flakes.

## Prerequisites

- **Nix 2.4+**: Install from [nixos.org](https://nixos.org/download)
    - Or I reccomend Lix or Determinite Nix as their setup is easier and can be uninstalled. 
- **Git**: For cloning this repository
- **SSH Key**: For secret management with agenix (will create if needed)

## Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/yourusername/home-manager.git
cd home-manager

# 2. Generate SSH key if you don't have one
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "your-email@example.com"

# 3. Set up access to private secrets repository
# Either: Set up GitHub SSH access for private repo
# Or: Use local override (see "Using Local Private Secrets" below)

# 4. Build and apply the configuration
home-manager switch --flake .#jason
```

## Detailed Setup Instructions

### Step 1: Install Nix and Enable Flakes

```bash
# Install Nix (if not already installed)
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes by adding to ~/.config/nix/nix.conf or /etc/nix/nix.conf
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Step 2: Generate SSH Keys

```bash
# Generate an ed25519 SSH key (recommended)
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "your-email@example.com"

# View your public key
cat ~/.ssh/id_ed25519.pub
```

### Step 3: Clone and Prepare Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/home-manager.git
cd home-manager
```

### Step 4: Set Up Private Secrets Repository

This configuration uses a separate private repository for secrets and personal variables.

#### Option A: Using GitHub Private Repository (Recommended)
```bash
# Ensure you have GitHub SSH access configured
ssh -T git@github.com  # Should show "Hi username!"

# The flake will automatically pull from private-secrets repo
```

#### Option B: Using Local Private Secrets
```bash
# Create a local private secrets directory
mkdir ../home-manager-private
cd ../home-manager-private

# Initialize as a flake
nix flake init

# Create your private configuration (see "Private Repository Structure" below)
# Then override the input when building:
cd ../home-manager
home-manager switch --flake .#jason --override-input private-secrets ../home-manager-private
```

### Step 5: Build and Apply Configuration

```bash
# Apply the configuration
home-manager switch --flake .#jason

# To test without applying
home-manager build --flake .#jason

# With local private secrets override
home-manager switch --flake .#jason --override-input private-secrets /path/to/private-secrets
```

## Architecture Overview

This configuration uses a two-repository approach:
- **Public repository**: Contains all non-sensitive configuration
- **Private repository**: Contains encrypted secrets and personal variables

### Private Repository Structure

Your private repository should contain:
```
home-manager-private/
├── flake.nix           # Exports homeManagerModules.default
├── default.nix         # Module with variables and secrets
├── secrets/
│   ├── secrets.nix     # Defines who can decrypt (SSH public keys)
│   └── *.age           # Encrypted secret files
```

Example `flake.nix` for private repo:
```nix
{
  outputs = { self, ... }: {
    homeManagerModules.default = ./default.nix;
  };
}
```

Example `default.nix` for private repo:
```nix
{ config, ... }: {
  # Personal variables
  my.variables = {
    full_name = "Your Name";
    code_email = "your@email.com";
    # ... other variables
  };
  
  # Agenix secrets configuration
  age.secrets = {
    # Define your encrypted secrets here
  };
}
```

## Secret Management with Agenix

This configuration uses [agenix](https://github.com/ryantm/agenix) for managing encrypted secrets within the private repository.

### Setting Up Agenix in Private Repository

1. Add your SSH public key to `secrets/secrets.nix` in your private repo:
```nix
let
  yourname = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...";
in {
  "secret-name.age".publicKeys = [ yourname ];
}
```

2. Create encrypted secrets in your private repo:
```bash
cd ~/home-manager-private
agenix -e secrets/github-token.age
```

3. Reference in your private repo's `default.nix`:
```nix
age.secrets.github-token = {
  file = ./secrets/github-token.age;
};
```

## Troubleshooting

### Common Issues

**"Could not find flake private-secrets"**
- Ensure you have SSH access to GitHub: `ssh -T git@github.com`
- Check that the private repo URL in `flake.nix` is correct
- Use `--override-input` for local development

**"No identity found" error with agenix**
- Ensure your SSH key exists: `ls ~/.ssh/id_ed25519`
- Check that your key is in `age.identityPaths` in the private repo
- Verify your public key is in the private repo's `secrets/secrets.nix`

**"Experimental features" error**
- Add `experimental-features = nix-command flakes` to your nix.conf
- Restart your shell or run `nix-daemon --version` to verify

**Build failures**
- Run `nix flake check` to validate the flake
- Check `home-manager news` for breaking changes
- Verify all options with `home-manager option <option-name>`

**Private repository access issues**
- Verify GitHub SSH access: `ssh -T git@github.com`
- Check SSH agent has your key: `ssh-add -l`
- Ensure private repo exists and you have access

### Verification Steps

```bash
# Check flake validity
nix flake check

# View flake outputs
nix flake show

# List current generations
home-manager generations

# Rollback if needed
home-manager rollback
```

## Organization Structure


```
.
├── flake.nix          # Main flake configuration
├── home.nix           # Base home configuration
├── modules/           # Feature-specific modules
│   ├── shell.nix     # Shell configuration (fish, bash, etc.)
│   ├── editor.nix    # Editor configurations
│   ├── secrets.nix   # Agenix secrets configuration
│   └── ...
└── secrets/           # Encrypted secrets (using agenix)
    ├── secrets.nix   # Defines who can decrypt secrets
    └── *.age         # Encrypted secret files
```

## Key Techniques

### Modular Design
- Each module is self-contained and focused on a single concern
- Modules use `mkEnableOption` for optional features
- Clear separation between programs, services, and system modules

### Theming with Catppuccin
- Unified theming solution using Catppuccin
- Global enable for all supported packages with `catppuccin.enable = true`
- Four flavors available: latte (light), frappe, macchiato, and mocha (dark variants)

### Secret Management with Agenix
- Encrypted secrets stored in the repository
- SSH key-based encryption/decryption
- Secrets decrypted at build time, never exposed in plain text

## Usage

### Building and Switching
```bash
# Test build without applying
home-manager build --flake .#jason

# Apply the configuration
home-manager switch --flake .#jason

# Check flake validity
nix flake check
```

### Development Guidelines
1. Always verify Home Manager options exist before use
2. Format code with `nixfmt .` before commits

## Inspirations
- [**vimjoyer's flake-starter-config**: Modular structure](https://github.com/vimjoyer/flake-starter-config)
- [**Mitchell Hashimoto's nixos-config**: Usage of flakes for importing specific software projects](https://github.com/mitchellh/nixos-config)
- [**Catppuccin**: Soothing pastel theme](https://github.com/catppuccin/nix)
- [**fzakaria**: For his Secret's for Dummies in nix guide](https://github.com/fzakaria/nix-home)
- [**Hydenix Project**: For helping me wrap my head around Hyprland on nixos.](https://github.com/richen604/hydenix) 
- [Omarchy](https://github.com/basecamp/omarchy) & [DHH:](https://github.com/dhh) For making me aware of [Hyperland](https://github.com/hyprwm/Hyprland)
- [Surma's Nix Explained from the Ground Up Video](https://www.youtube.com/watch?v=5D3nUU1OVx8)

