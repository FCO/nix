{ pkgs, inputs, self, primaryUser, nvimRepo, ... }:
{
  # imports removed for evaluation simplicity
  # imports = [
  #   inputs.sops-nix.nixosModules.sops
  # ];

  # Common services for VM
  services.openssh.enable = true;

  # Samba disabled for evaluation simplicity
  # services.samba.enable = false;



  # Enable xrdp for remote desktop (RDP)
  # Disable xrdp for simpler evaluation; re-enable when needed
  services.xrdp.enable = false;

  # Firewall: open common ports similar to mac and Samba/RDP
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 445 139 5900 3283 3689 3389 ];
    allowedUDPPorts = [ 5353 ];
  };

  users.users.${primaryUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # Home Manager inside NixOS disabled for flake check simplicity
  # environment.systemPackages minimal
  environment.systemPackages = [ pkgs.openssh ];
}