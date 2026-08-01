{ config, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.polkit.enable = true;

  # Hyprlock needs its own PAM service to authenticate (config comes from
  # the symlinked dots/.config/hypr/hyprlock.conf), otherwise it falls back to su
  security.pam.services.hyprlock = { };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde   # needed for Quickshell's bluetooth/network kcmshell6 launches
    ];
    config.common.default = "*";
  };

  # Location services – used by Quickshell's night-light / sunset logic
  services.geoclue2.enable = true;

  # Keyring – used by Quickshell + various apps for secret storage
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # ydotoold daemon – required by ydotool, used by Quickshell for input simulation
  programs.ydotool.enable = true;

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # Only the bare minimum – everything else goes into Home Manager
  environment.systemPackages = with pkgs; [
    xdg-utils
    wl-clipboard
  ];
}