{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  # extra per-user (optional)
  home.packages = with pkgs; [ ];
}
