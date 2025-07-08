# Template for private variables
# Copy this file to private/variables.nix and fill in your actual values
# private/variables.nix is gitignored and won't be committed

{ ... }:
{
  my.variables = {
    # Private email addresses
    personal_email = "your.personal@email.com";
    work_email = "your.work@company.com";

    # Physical address information
    address = "123 Your Street";
    city = "Your City";
    state = "XX"; # Two-letter state/province code
    zip = "12345";

    # Add any other private variables you need below
    # ...
  };
}
