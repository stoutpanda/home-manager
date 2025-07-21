# Template overlay for pulling packages from nixpkgs-master when needed
# This can be used when packages have build issues in stable nixpkgs
# Example usage:
# packageName = final.nixpkgs-master.packageName;
final: prev: {
  # Add package overrides here as needed
}