{ pkgs, lib, config, nvimRepo, ... }:
{
  imports = [
    ../packages.nix
    ../git.nix
    ../shell.nix
  ] ++ lib.optional (builtins.pathExists ../wayland.nix) ../wayland.nix;

  # Shared configuration for family users
  home.stateVersion = "25.05";

  # Provide Neovim config like primary user
  home.file.".config/nvim".source = nvimRepo;

  # Ensure fastfetch/rakudo/zef available for banner
  home.packages = [
    pkgs.fastfetch
    pkgs.neofetch
    pkgs.rakudo
    pkgs.zef
  ];

  # macOS-only: link to system wallpapers
  home.file."Wallpapers" = lib.mkIf pkgs.stdenv.isDarwin {
    source = lib.file.mkOutOfStoreSymlink "/System/Library/Desktop Pictures";
  };
}

