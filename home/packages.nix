{ pkgs, ... }:
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

      neovim

      # misc
      nil
      biome
      nixfmt-rfc-style
      yt-dlp
      ffmpeg
      ollama

      # fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono

      pokemonsay
      coreutils
    ];
  };
}
