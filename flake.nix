{
  description = "Home Manager configuration for StoutPanda";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    #home manager required
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #secrets mgmt with agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #chaotic nyx for bleeding edge and cachyos optimized pkgs and kernals
    chaotic = {
      url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";#"github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #ghostty terminal emulator
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyVim = {
      url = "github:matadaniel/LazyVim-module";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    #catppuccin theming
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #firefox extensions
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #zen-browser
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    #iamb matrix client
    iamb.url = "github:ulyssa/iamb/latest";
    
    # Private secrets and variables
    # Use --override-input to specify local path or private git URL
    private-secrets = {
      url = "git+ssh://git@github.com/stoutpanda/home-manager-private.git";
      flake = true;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-master,
      home-manager,
      agenix,
      chaotic,
      ghostty,
      lazyVim,
      catppuccin,
      firefox-addons,
      zen-browser,
      iamb,
      private-secrets,
      ...
    }@inputs:
    let
      # Helper function for multi-system support
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      
      # Function to get pkgs for a specific system
      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [
          # Overlay for pulling packages from nixpkgs-master when needed (e.g., build fixes)
          (final: prev: {
            # Add packages here that need to be pulled from nixpkgs-master
            # Example: packageName = nixpkgs-master.legacyPackages.${system}.packageName;
          })
        ];
        config.allowUnfree = true;
      };
      
      # Helper function to create a user configuration
      mkUserConfig = system: username: home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor system;
        
        modules = [
          ./home.nix
          agenix.homeManagerModules.default
          chaotic.homeManagerModules.default
          catppuccin.homeModules.catppuccin
          lazyVim.homeManagerModules.default
          private-secrets.homeManagerModules.default
          {
            home.stateVersion = "25.05";
          }
        ];
        
        extraSpecialArgs = { inherit inputs; };
      };
    in
    {
      # Note: Flake outputs must be statically defined, so we can't use variables here.
      # To support multiple users, add additional homeConfigurations entries.
      # The actual username/homeDirectory are set via modules/variables.nix
      homeConfigurations = {
        # Default user configuration for x86_64-linux
        "jason" = mkUserConfig "x86_64-linux" "jason";
        
        # Example: Add more users like this:
        # "another-user" = mkUserConfig "x86_64-linux" "another-user";
        
        # Example: Add ARM64 support:
        # "jason@aarch64" = mkUserConfig "aarch64-linux" "jason";
      };

      # Convenience scripts for applying configurations
      apps = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = {
            type = "app";
            program = "${pkgs.writeShellScript "switch" ''
              home-manager switch --flake .#jason
            ''}";
          };

          build = {
            type = "app";
            program = "${pkgs.writeShellScript "build" ''
              home-manager build --flake .#jason
            ''}";
          };
        }
      );
    };
}
