{
  description = "Home Manager configuration for StoutPanda";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
   #home manager required 
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #all theming with stylix  
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #secrets mgmt with agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #chaotic nyx for bleeding edge and cachyos optimized pkgs and kernals
    chaotic = {
        url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
    #ghostty terminal emulator
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, agenix, chaotic, ghostty, ... }@inputs:
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
          chaotic.homeManagerModules.default
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "25.05"; # Please check the latest version
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
