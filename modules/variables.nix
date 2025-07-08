{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.variables;
in
{
  options.my.variables = {
    # Public variables - safe for GitHub
    local_user = mkOption {
      type = types.str;
      default = "jason";
      description = "Local system username";
    };

    full_name = mkOption {
      type = types.str;
      default = "Jason Holder";
      description = "Full name";
    };

    code_email = mkOption {
      type = types.str;
      default = "stoutpanda@protonmail.com";
      description = "Public code/development email";
    };

    code_user = mkOption {
      type = types.str;
      default = "StoutPanda";
      description = "GitHub/GitLab username";
    };

    # Private variables - will be overridden in private/variables.nix
    personal_email = mkOption {
      type = types.str;
      default = "personal@example.com";
      description = "Personal email address";
    };

    work_email = mkOption {
      type = types.str;
      default = "work@example.com";
      description = "Work email address";
    };

    address = mkOption {
      type = types.str;
      default = "123 Main St";
      description = "Street address";
    };

    city = mkOption {
      type = types.str;
      default = "Anytown";
      description = "City";
    };

    state = mkOption {
      type = types.str;
      default = "TX";
      description = "State/Province";
    };

    zip = mkOption {
      type = types.str;
      default = "12345";
      description = "ZIP/Postal code";
    };
  };
}
