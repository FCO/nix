{
  pkgs,
  inputs,
  self,
  primaryUser,
  nvimRepo,
  ...
}:
{
  imports = [
    ./homebrew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.sops-nix.darwinModules.sops
  ];

  # nix config
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # disabled due to https://github.com/NixOS/nix/issues/7273
      # auto-optimise-store = true;

      # hygiene: caches and keys
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.determinate.systems"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:eWNHVY7Z8Im2YPNvPSt9sVNfz1xQ2HfW7S1fLkQ6WJw="
        "determinate.systems:4Z9p8eE8aKfKpFvSG3N7sN56wG0n2Q8bQ0Yw5Rz2V9U="
      ];
    };

    enable = false; # using determinate installer
  };

  nixpkgs.config.allowUnfree = true;

  # homebrew installation manager
  nix-homebrew = {
    user = primaryUser;
    enable = true;
    autoMigrate = true;
  };

  # home-manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${primaryUser} = {
      imports = [
        ../home
      ];
    };
    extraSpecialArgs = {
      inherit inputs self primaryUser nvimRepo;
    };
  };

  # macOS-specific settings
  system.primaryUser = primaryUser;
  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = pkgs.zsh;
  };
  users.users.fernanda = {
    home = "/Users/fernanda";
    shell = pkgs.zsh;
  };
  users.users.sophia = {
    home = "/Users/sophia";
    shell = pkgs.zsh;
  };
  users.users.aline = {
    home = "/Users/aline";
    shell = pkgs.zsh;
  };
  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
}
