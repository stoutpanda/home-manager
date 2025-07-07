{
  description = "Home Manager configuration for StoutPanda";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, agenix, ... }@inputs:
    let
      system = "x86_64-linux"; # Change this to your system
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Your username and home directory
      username = "jason"; # Change this to your username
      homeDirectory = "/home/${username}";
    in
    {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here
        modules = [
          ./home.nix
          stylix.homeManagerModules.stylix
          agenix.homeManagerModules.default
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "24.05"; # Please check the latest version
            };
          }
        ];

        # Pass special args to your modules
        extraSpecialArgs = { inherit inputs; };
      };

      # Convenience scripts for applying configurations
      apps.${system} = {
        default = {
          type = "app";
          program = "${pkgs.writeShellScript "switch" ''
            home-manager switch --flake .#${username}
          ''}";
        };
        
        build = {
          type = "app";
          program = "${pkgs.writeShellScript "build" ''
            home-manager build --flake .#${username}
          ''}";
        };
      };
    };
}
