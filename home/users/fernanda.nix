{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  home.packages = with pkgs; [ tree pokemonsay ];

  programs.zsh.shellAliases = { lsla = "ls -la"; };
}
