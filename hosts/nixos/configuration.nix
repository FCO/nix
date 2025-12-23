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

  # Display manager disabled for now
  services.greetd.enable = false;

  # Wayland sessions and desktop stack
  programs.uwsm.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
  };
  programs.hyprland.enable = true;

  hardware.graphics.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.dbus.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-hyprland ];
  };

  services.xserver.videoDrivers = [ "virtio" ];
  services.xserver.enable = false; # pure Wayland

  # Networking and SSH
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  # Fonts and Wayland utilities
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira
    fira-code
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
  ];

  environment.systemPackages = with pkgs; [
    niri
    waybar
    wofi
    mako
    grim
    slurp
    wl-clipboard
    wlogout
    swww
    foot
    wezterm
    brightnessctl
    upower
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
  ];

  environment.variables.NIXOS_OZONE_WL = "1";
}
