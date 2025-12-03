{
  description = "My system configuration";
  inputs = {
    # monorepo w/ recipes ("derivations")
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # manages configs
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-level software and settings (macOS)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # declarative homebrew management
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # secrets management via sops-nix
    sops-nix.url = "github:Mic92/sops-nix";

    # local flake providing pokewelcome package (assets + script)
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

      # Expose Home Manager standalone configuration for 'hm' alias
      homeConfigurations."fernando" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./home ];
        extraSpecialArgs = { inherit inputs self primaryUser nvimRepo; };
      };
    };
}
