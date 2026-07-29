{ config, pkgs, ... }:
{
  # Bootloader: systemd-boot for UEFI (recommended)
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    # If you want dual-boot with Windows or a timeout for OS selection:
    timeout = 5;
  };

  # Kernel parameters – nixos-hardware adds some, these are safe extras
  boot.kernelParams = [
    "quiet"           # less verbose boot
    "splash"          # show plymouth splash (if installed)
    # "i915.fastboot=1"   # faster Intel graphics init (optional)
  ];

  # NVIDIA DRM modeset – already enabled by nixos-hardware,
  # but you can keep it explicit if you prefer
  # boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Kernel packages – use latest for better hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # Optional: Plymouth for a graphical boot splash
  # services.plymouth.enable = true;
}