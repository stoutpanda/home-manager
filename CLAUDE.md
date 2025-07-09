# Nix Home Manager Configuration Project

## Project Overview
This is a Nix Home Manager configuration project using flakes for user environment management. The project follows a modular approach to keep configurations simple, maintainable, and reusable.

## Code Style & Formatting
- Use `nixfmt` for Nix code formatting (run `nixfmt .` before commits)
- 2-space indentation for all Nix files
- Follow nixpkgs conventions for package expressions
- Attribute sets should have consistent formatting with closing braces aligned
- One attribute per line for readability in complex expressions
- Use `rec` sparingly - prefer `let...in` for clarity

## Project Structure
```
.
├── flake.nix          # Main flake configuration
├── home.nix           # Base home configuration
├── modules/           # Feature-specific modules
│   ├── shell.nix     # Shell configuration (zsh, bash, etc.)
│   ├── editor.nix    # Editor configurations
│   ├── dev.nix       # Development tools
│   ├── desktop.nix   # Desktop environment configs
│   └── secrets.nix   # Agenix secrets configuration
├── programs/          # Program-specific configurations
│   ├── git.nix       # Git configuration
│   ├── tmux.nix      # Tmux configuration
│   └── ...
├── services/          # Service configurations
│   ├── syncthing.nix # Syncthing service
│   └── ...
└── secrets/           # Encrypted secrets
    ├── secrets.nix   # Defines who can decrypt secrets
    └── *.age         # Encrypted secret files
```

## Development Workflow

### Before Making Changes
1. Always verify Home Manager options exist using: `mcp__nixos__home_manager_info`
2. Search for options with: `mcp__nixos__home_manager_search`
3. Check option prefixes with: `mcp__nixos__home_manager_options_by_prefix`
4. For package availability, use: `mcp__nixos__nixos_search`

### Building and Testing
- Test build: `home-manager build --flake .#jason`
- Apply changes: `home-manager switch --flake .#jason`
- Check flake: `nix flake check`
- Update inputs: `nix flake update`
- **Dry Run Tip**: Always use `home-manager build` for a dry run before `switch`

### Formatting and Linting
- Format all Nix files: `nixfmt .`
- Verify formatting before commits
- Use `nix-instantiate --parse` to check for syntax errors

## Module Guidelines

### Creating New Modules
1. Each module should be self-contained and focused on a single concern
2. Use `mkEnableOption` for optional features
3. Provide sensible defaults
4. Document options clearly
5. Example module structure:
```nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.myprogram;
in {
  options.programs.myprogram = {
    enable = mkEnableOption "myprogram";
    
    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Configuration for myprogram";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.myprogram ];
    # ... additional configuration
  };
}
```

## Key Principles
1. **Keep it simple but modular** - Each module should do one thing well
2. **Always verify before implementing** - Use MCP tools to check option availability
3. **Ask for clarification** - When uncertain, always ask. Asking is success!
4. **Read entire files** - Always read complete files before making edits
5. **Test incrementally** - Build and test after each significant change
6. **Document decisions** - Add comments for non-obvious configuration choices

## Theming
- **Use Catppuccin for all theming** - Catppuccin provides a unified theming solution
- Global enable with `catppuccin.enable = true` for all supported packages
- Choose from four flavors: latte (light), frappe, macchiato, mocha (dark)
- Automatically themes all supported applications
- Avoid manual color configurations when Catppuccin can handle it

## Sources of Inspiration
- **vimjoyer's flake-starter-config**: https://github.com/vimjoyer/flake-starter-config
  - Excellent modular structure and organization
  - Clean separation of concerns
  - Note: We're keeping home-manager separate for now (not integrated with NixOS)
- **Mitchell Hashimoto's nixos-config**: https://github.com/mitchellh/nixos-config/blob/main/users/mitchellh/home-manager.nix
  - Professional developer setup with thoughtful choices
  - Good examples of program configurations
  - Well-documented approach to personal tooling
- **Catppuccin examples**: https://github.com/catppuccin/nix
- **Home Manager community configs**: Search GitHub for real-world examples

## Tooling & Development Environment
- **Formatter**: `nixfmt` (from https://github.com/NixOS/nixfmt)
- **Language Server**: `nil` or `nixd` for LSP support
- **REPL**: `nix repl` for testing expressions
- **Flake utilities**:
  - `nix flake show` - Display flake outputs
  - `nix flake metadata` - Show flake information
  - `nix flake check` - Validate flake
- **Home Manager CLI**:
  - `home-manager generations` - List all generations
  - `home-manager rollback` - Rollback to previous generation
  - `home-manager news` - Show news about changes

## Tool Usage
- **NixOS MCP**: Always verify options and configurations
- **Context7 MCP**: Use for library documentation lookups
- **Brave Search**: Use for web searches and finding examples
- **Version lookups**: Use `mcp__nixos__nixhub_package_versions` for specific package versions

## Common Tasks

### Adding a New Program
1. Check if program exists: `mcp__nixos__nixos_search "program-name"`
2. Find Home Manager options: `mcp__nixos__home_manager_search "program-name"`
3. Create module in `programs/` directory
4. Import in `home.nix`
5. Test with `home-manager build`

### Managing Secrets
1. Create secret: `echo "secret-value" | agenix -e secrets/secret-name.age`
2. Add to `modules/secrets.nix`
3. Reference with `config.age.secrets.secret-name.path`
4. Never log or print secret values
5. See `AGENIX_GUIDE.md` for detailed examples

### Configuring Catppuccin Theme
1. Catppuccin is already included in `flake.nix` inputs
2. Configure in `modules/theme.nix`:
   ```nix
   { config, lib, pkgs, ... }: {
     # Global enable for all supported packages
     catppuccin.enable = true;
     
     # Set the flavor (latte, frappe, macchiato, mocha)
     catppuccin.flavor = "mocha";
   }
   ```
3. Catppuccin will automatically theme all supported applications
4. Check [Catppuccin nix docs](https://nix.catppuccin.com) for package-specific overrides

### Debugging
- Use `home-manager news` to see recent changes
- Check logs with `journalctl --user`
- Validate option types match expected values
- Use `nix repl` to test expressions

## Secrets Management

### Overview
We use `agenix` for managing encrypted secrets. Secrets are encrypted with age using SSH public keys and stored in the repository. They're decrypted at `home-manager switch` time using your SSH private key.

### Quick Reference
- **Secrets definition**: `secrets/secrets.nix` - defines recipients (who can decrypt)
- **Secrets configuration**: `modules/secrets.nix` - configures agenix module
- **Encrypted secrets**: `secrets/*.age` - safe to commit
- **Decrypted location**: `~/.config/agenix/` - never commit!
- **Guide**: See `AGENIX_GUIDE.md` for detailed usage

### Common Commands
```bash
# Encrypt a new secret
agenix -e secrets/my-secret.age

# Edit existing secret
agenix -e secrets/my-secret.age

# Re-encrypt all secrets (after adding new recipients)
agenix -r
```

### Adding Secrets to Modules
1. Add recipient to `secrets/secrets.nix`
2. Define secret in `modules/secrets.nix`:
   ```nix
   age.secrets.my-secret = {
     file = ../secrets/my-secret.age;
   };
   ```
3. Use in configuration:
   ```nix
   someOption = config.age.secrets.my-secret.path;
   ```

## Git Workflow
- Never include `/result` symlinks in commits
- Format code before committing
- Use descriptive commit messages following conventional commits
- Test configuration before pushing

## Security Considerations
- Never commit secrets or API keys
- We use `agenix` for secret management (see Secrets Management section)
- Review all external flake inputs
- Keep flake inputs updated for security patches
- Encrypted secrets (*.age files) are safe to commit
- Never commit decrypted secrets or the agenix runtime directories

## Performance Tips
- Use `nixpkgs.config.allowUnfree` judiciously
- Minimize use of IFD (Import From Derivation)
- Prefer binary caches when available
- Use `nix.gc` settings to manage disk usage

## Troubleshooting Checklist
1. Syntax error? Run `nix-instantiate --parse file.nix`
2. Option not found? Verify with MCP tools
3. Build fails? Check `home-manager news` for breaking changes
4. Unexpected behavior? Review recent commits
5. Performance issues? Profile with `nix-store --optimise`

## Tips and Tricks
- **Dry Run Best Practice**: Always use dry run only on home-manager rebuilds to verify changes before applying