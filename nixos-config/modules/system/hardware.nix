# modules/system/hardware.nix
{ config, pkgs, ... }:
{
  # Intel VA-API hardware video acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  # NVIDIA Optimus Prime offload
  hardware.nvidia = {
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;   # provides 'prime-run' command
      }; 

      intelBusId  = "PCI:0:2:0";   # Intel UHD Graphics
      nvidiaBusId = "PCI:1:0:0";   # NVIDIA GeForce MXxxx
    };
  };

  # Laptop power management (TLP)
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

}