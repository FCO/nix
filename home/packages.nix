{ pkgs, inputs, ... }:
{
  home = {
    packages = (with pkgs; [
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
      sops
      age
      nix-search-cli

      # fastfetch/neofetch + raku for startup banner
      fastfetch
      neofetch
      rakudo
      zef

      coreutils
    ])
    ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) (with pkgs; [
      pokemon-colorscripts
      ollama
    ]);
  };
}

