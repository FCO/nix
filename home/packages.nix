{ pkgs, inputs, ... }:
{
  home = {
    packages = with pkgs; [
      # dev tools
      curl
      vim
      htop
      tree
      ripgrep
      zoxide
      git
      neovim

      # misc
      nil
      biome
      nixfmt-rfc-style
      yt-dlp
      ffmpeg
      ollama
      sops
      age
      nix-search-cli

      # fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono

      # pokemon welcome assets + script from local flake
      (inputs.pokewelcome.packages.${pkgs.system}.default)

      coreutils

      # Home Manager CLI on PATH
      (inputs.home-manager.packages.${pkgs.system}.default)
    ];
  };
}

