# Home Manager Configuration

This repository contains my Nix Home Manager configuration using flakes.

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
├── programs/          # Program-specific configurations
│   ├── git.nix       # Git configuration
│   ├── tmux.nix      # Tmux configuration
│   └── ...
├── services/          # Service configurations
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

### Theming with Stylix
- Unified theming solution using Stylix
- Single source of truth for colors, fonts, and visual settings

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
- [**Stylix**: Comprehensive theming approach](https://github.com/nix-community/stylix)
- [**fzakaria**: For his Secret's for Dummies in nix guide](https://github.com/fzakaria/nix-home)
- [**Hydenix Project**: For helping me wrap my head around Hyprland on nixos.](https://github.com/richen604/hydenix) 
- [Omarchy](https://github.com/basecamp/omarchy) & [DHH:](https://github.com/dhh) For making me aware of [Hyperland](https://github.com/hyprwm/Hyprland)
- [Surma's Nix Explained from the Ground Up Video](https://www.youtube.com/watch?v=5D3nUU1OVx8)

