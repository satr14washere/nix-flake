{
  description = "satr14's nix flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gl.url = "github:nix-community/nixGL";
    ctp.url = "github:catppuccin/nix";
  };

  outputs = inputs: let 
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      overlays = [ inputs.gl.overlay ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "ventoy-qt5-1.1.10" ];
      };
    };
    args = {
      inherit inputs;
    } // import ./lib/options.nix;

    nixosConfig = host: inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = args;
      modules = [
        ./hosts/${host}/config.nix
      ];
    };
    
    nixosConfigWithHome = host: inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = {
        hostname = host;
      } // args;
      modules = [
        ./hosts/${host}/config.nix
        inputs.ctp.nixosModules.catppuccin
        inputs.hm.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = args;
            backupFileExtension = ".hm-backup";
            users.${args.username} = import ./hosts/${host}/home.nix;
            sharedModules = [ inputs.ctp.homeModules.catppuccin ];
          };
        }
      ];
    };
  in  {
    nixosConfigurations = {
      thinkpad = nixosConfigWithHome "thinkpad";
      homelab = nixosConfig "homelab";
    };
  };
}
