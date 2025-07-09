# Thunderbird Configuration Plan

## Overview
This document outlines the setup for Thunderbird email client in Home Manager with multiple email accounts using age-encrypted passwords.

## Email Accounts to Configure
1. **Personal (notacc.net)** - Migadu hosting
2. **Personal Gmail** - Standard Gmail
3. **Work (trendhr.com)** - Office 365
4. **TDFW (touchupdfw.com)** - Google Workspace

## Server Settings (stored in private/variables.nix)
```nix
email_servers = {
  notacc = {
    imap = { host = "imap.migadu.com"; port = 993; };
    smtp = { host = "smtp.migadu.com"; port = 465; };
  };
  trendhr = {
    imap = { host = "outlook.office365.com"; port = 993; };
    smtp = { host = "smtp.office365.com"; port = 587; };
  };
  touchupdfw = {
    imap = { host = "imap.gmail.com"; port = 993; };
    smtp = { host = "smtp.gmail.com"; port = 587; };
  };
  gmail = {
    imap = { host = "imap.gmail.com"; port = 993; };
    smtp = { host = "smtp.gmail.com"; port = 587; };
  };
};
```

## Implementation Steps

### 1. Create Age-Encrypted Password Files
Create encrypted password files for each account:
```bash
agenix -e secrets/email-personal-password.age
agenix -e secrets/email-personal-gmail-password.age
agenix -e secrets/email-work-password.age
agenix -e secrets/email-tdfw-password.age
```

### 2. Update secrets/secrets.nix
Add the password files to the secrets configuration:
```nix
{
  "email-personal-password.age".publicKeys = users ++ systems;
  "email-personal-gmail-password.age".publicKeys = users ++ systems;
  "email-work-password.age".publicKeys = users ++ systems;
  "email-tdfw-password.age".publicKeys = users ++ systems;
}
```

### 3. Update modules/secrets.nix
Add age secrets configuration:
```nix
age.secrets = {
  email-personal-password = {
    file = ../secrets/email-personal-password.age;
    mode = "600";
  };
  email-personal-gmail-password = {
    file = ../secrets/email-personal-gmail-password.age;
    mode = "600";
  };
  email-work-password = {
    file = ../secrets/email-work-password.age;
    mode = "600";
  };
  email-tdfw-password = {
    file = ../secrets/email-tdfw-password.age;
    mode = "600";
  };
};
```

### 4. Create modules/de/thunderbird.nix
The module will:
- Enable Thunderbird package
- Create a default profile
- Configure all four email accounts
- Use `passwordCommand` to read from age-decrypted secrets
- Pull email addresses from `config.my.variables`
- Pull server settings from `config.my.variables.email_servers`

Example account configuration:
```nix
accounts.email.accounts.personal = {
  primary = true;
  address = config.my.variables.personal_email;
  realName = config.my.variables.full_name;
  
  imap = {
    host = config.my.variables.email_servers.notacc.imap.host;
    port = config.my.variables.email_servers.notacc.imap.port;
    tls.enable = true;
  };
  
  smtp = {
    host = config.my.variables.email_servers.notacc.smtp.host;
    port = config.my.variables.email_servers.notacc.smtp.port;
    tls.enable = true;
  };
  
  passwordCommand = "cat ${config.age.secrets.email-personal-password.path}";
  
  thunderbird = {
    enable = true;
    profiles = [ "default" ];
  };
};
```

### 5. Update modules/de/default.nix
Add the import:
```nix
imports = [
  ./ghostty.nix
  ./bitwarden.nix
  ./browsers/default.nix
  ./thunderbird.nix  # Add this line
];
```

## Current Status
- ✅ Updated private/variables.nix with email server settings
- ✅ Updated modules/variables.nix with new option definitions
- ⏳ Need to create age-encrypted password files
- ⏳ Need to update secrets configurations
- ⏳ Need to create thunderbird.nix module
- ⏳ Need to update de/default.nix imports

## Notes
- All sensitive data (passwords) stored in age-encrypted files
- Server settings stored in private variables file (not sensitive)
- Module follows existing patterns from Firefox configuration
- Uses declarative email account configuration from Home Manager