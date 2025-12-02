{ ... }:
{
  # Shared configuration for family users
  home.stateVersion = "25.05";

  programs.zsh.enable = true;

  # Link to original macOS wallpapers (no copy)
  home.file."Wallpapers".source = "/System/Library/Desktop Pictures";
}
