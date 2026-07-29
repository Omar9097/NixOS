{ config, pkgs, ... }:
{
  # Hostname (change to your liking)
  networking.hostName = "Blue";

  # NetworkManager – the standard for laptops with WiFi
  networking.networkmanager.enable = true;

  # Firewall – enabled by default, but explicit
  networking.firewall.enable = true;

  # Allow common desktop services (if you need them)
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Enable wireless support (NetworkManager handles it)
  networking.wireless.enable = false;  # conflicting with NetworkManager

  # Optional: enable `nss-mdns` for .local hostname resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}