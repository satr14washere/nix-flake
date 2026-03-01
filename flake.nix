{
  description = "satr14's nix flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops.url = "github:Mic92/sops-nix";
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
      specialArgs = args // { hostname = host; };
      modules = [
        ./hosts/${host}/config.nix
        inputs.ctp.nixosModules.catppuccin
        inputs.sops.nixosModules.sops
      ];
    };
    
    nixosConfigWithHome = host: inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = args // { hostname = host; };
      modules = [
        ./hosts/${host}/config.nix
        inputs.ctp.nixosModules.catppuccin
        inputs.sops.nixosModules.sops
        inputs.hm.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = args // { hostname = host; };
            backupFileExtension = ".hm-backup";
            users.${args.username} = import ./hosts/${host}/home.nix;
            sharedModules = [ inputs.ctp.homeModules.catppuccin ];
          };
        }
      ];
    };
    
    homeConfig = host: inputs.hm.lib.homeManagerConfiguration {
      extraSpecialArgs = args // { hostname = host; };
      inherit pkgs;
      modules = [
        ./hosts/${host}/home.nix
        inputs.ctp.homeModules.catppuccin
      ];
    };
  in  {
    nixosConfigurations = {
      thinkpad = nixosConfigWithHome "thinkpad";
      homelab = nixosConfig "homelab";
      bootstrap = nixosConfig "bootstrap";
    };
    homeConfigurations = {
      bootstrap = homeConfig "bootstrap";
    };
  };
}
