{ pkgs, primaryUser, lib, ... }:
{
  networking.hostName = "nixos";

  system.stateVersion = "25.11";
  programs.zsh.enable = true;

  # Minimal boot loader + root FS for evaluation
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # Disable display manager and heavy desktop services
  services.greetd.enable = false;

  # Keep only essential services
  services.openssh.enable = true;
  networking.networkmanager.enable = true;

  # Primary user (also defined in nixos/default.nix; safe to keep here)

}
