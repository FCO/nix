{ config, nvimRepo, ... }:
{
  imports = [
    ../packages.nix
    ../git.nix
    ../shell.nix
  ];

  # Shared configuration for family users
  home.stateVersion = "25.05";

  # Provide Neovim config like primary user
  home.file.".config/nvim".source = nvimRepo;

  # Link to original macOS wallpapers (no copy, out-of-store symlink)
  home.file."Wallpapers".source = config.lib.file.mkOutOfStoreSymlink "/System/Library/Desktop Pictures";
}
