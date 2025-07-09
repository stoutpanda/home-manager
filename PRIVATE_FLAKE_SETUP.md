# Private Flake Setup

This project uses a separate private flake to manage sensitive data like email addresses, passwords, and server configurations. This keeps your private information separate from the public repository.

## Structure

Your private flake is stored in a private GitHub repository:
- GitHub: https://github.com/stoutpanda/home-manager-private (PRIVATE)
- Local: `~/home-manager-private/`

It contains:
- `flake.nix` - Exports variables and secrets modules
- `variables.nix` - Your private email addresses and server configurations
- `secrets-module.nix` - Age secret definitions
- `secrets/` - Age-encrypted password files
- `secrets/secrets.nix` - Defines who can decrypt secrets

## Usage

### Building/Switching

The private flake is already configured as an input in the main flake. Simply run:

```bash
home-manager switch --flake .#jason
```

### Updating Passwords

To update an encrypted password in the private repo:

```bash
cd ~/home-manager-private
nix run github:ryantm/agenix -- -e secrets/email-personal-password.age
# Enter your password when prompted
git add -A && git commit -m "Update password"
```

### Adding New Secrets

1. Create the encrypted file in `~/home-manager-private/secrets/`
2. Add it to `~/home-manager-private/secrets/secrets.nix`
3. Add the age secret definition to `~/home-manager-private/secrets-module.nix`
4. Commit changes in the private repo

### Using Different Private Flake Location

If you move the private flake or want to use a different source:

```bash
# Use a local path
nix flake update --override-input private-secrets /path/to/private-flake

# Use a private git repository
nix flake update --override-input private-secrets git+ssh://git@github.com/username/private-repo
```

## Security Notes

- **NEVER** push the private flake to a public repository
- Keep the private flake backed up securely
- The main repository can be safely made public - it contains no sensitive data
- All sensitive data is now isolated in the private flake

## Thunderbird Email Setup

The Thunderbird configuration uses the private flake for:
- Email addresses (personal_email, work_email, etc.)
- Email server configurations (IMAP/SMTP settings)
- Encrypted passwords for each account

To use Thunderbird, ensure all password files in the private flake are properly encrypted with your actual passwords.