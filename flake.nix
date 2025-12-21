{
  description = "My system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    sops-nix.url = "github:Mic92/sops-nix";
    pokewelcome.url = "path:/Users/fernando/.local/pokewelcome-flake";
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      ...
    }@inputs:
    let
      primaryUser = "fernando";
      nvimRepo = builtins.fetchGit {
        url   = "https://github.com/FCO/kickstart.nvim.git";
        rev   = "f9085e5510e774461ec78748fe4605d8955de166";
      };

    in
    {
      darwinConfigurations."FCO" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin
          ./hosts/FCO/configuration.nix
        ];
        specialArgs = { inherit inputs self primaryUser nvimRepo; };
      };

      homeConfigurations."${primaryUser}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./home ];
        extraSpecialArgs = { inherit inputs self primaryUser nvimRepo; };
      };
    };
}
