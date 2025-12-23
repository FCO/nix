{ pkgs, inputs, self, primaryUser, nvimRepo, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # Common services for VM
  services.openssh.enable = true;

  # Samba (SMB) server
  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "VM Samba";
        "netbios name" = "VM";
        "security" = "user";
        "map to guest" = "Bad User";
      };
      "Public" = {
        path = "/srv/samba/Public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };



  # Enable xrdp for remote desktop (RDP)
  # Enable xrdp for remote desktop (RDP)
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xterm";

  # Firewall: open common ports similar to mac and Samba/RDP
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 445 139 5900 3283 3689 3389 ];
    allowedUDPPorts = [ 5353 ];
  };

  # Ensure share directory exists and is owned by users group
  systemd.tmpfiles.rules = [
    "d /srv/samba/Public 0775 root users - -"
  ];

  users.users.${primaryUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # Home Manager inside NixOS
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs self primaryUser nvimRepo; };
    users = {};
  };

  environment.systemPackages = [ pkgs.openssh ];
}