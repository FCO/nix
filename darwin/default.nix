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
    backupFileExtension = "backup";

    users.${primaryUser} = {
      imports = [
        ../home
      ];
    };

    # family users
    users.fernanda = {
      imports = [ ../home/users/fernanda.nix ];
    };
    users.sophia = {
      imports = [ ../home/users/sophia.nix ];
    };
    users.aline = {
      imports = [ ../home/users/aline.nix ];
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
   services.openssh.enable = true;

    environment.etc."pf-nix.conf".text = ''
      set skip on lo0
      pass out all keep state
      pass in proto tcp from any to self port { 22 445 139 5900 3283 3689 }
      pass in proto udp from any to self port { 5353 }
    '';

    system.activationScripts.pf.text = ''
      /sbin/pfctl -f /etc/pf-nix.conf || true
      /sbin/pfctl -e || true
    '';

  environment = {
    systemPath = [
      "/usr/bin"
      "/opt/homebrew/bin"
      "/run/current-system/sw/bin"
      "/nix/var/nix/profiles/default/bin"
    ];
    pathsToLink = [ "/Applications" ];
    systemPackages = [ pkgs.openssh pkgs.homepage-dashboard ];
  };
}
