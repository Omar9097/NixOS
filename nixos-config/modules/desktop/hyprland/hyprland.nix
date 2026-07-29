# modules/desktop/hyprland.nix
{ config, pkgs, ... }:

{
  # ------------------------------------------------------------
  # Hyprland – Wayland compositor
  # ------------------------------------------------------------
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;    # for legacy X11 apps, works with NVIDIA offload
  };

  # ------------------------------------------------------------
  # Polkit – required for GUI privilege escalation
  # ------------------------------------------------------------
  security.polkit.enable = true;

  # ------------------------------------------------------------
  # XDG Desktop Portal – needed for screen sharing & file dialogs
  # ------------------------------------------------------------
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk      # for GTK-based file picker
      xdg-desktop-portal-hyprland # Hyprland-specific portal (screenshot, etc.)
    ];
    config.common.default = "*";   # use the portals by default
  };

  # ------------------------------------------------------------
  # Environment variables for NVIDIA + Wayland
  # ------------------------------------------------------------
  environment.sessionVariables = {
    # Force Firefox/Chromium to use Wayland backend
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";            # Electron apps prefer Wayland

    # NVIDIA hardware acceleration
    LIBVA_DRIVER_NAME = "nvidia";

    # If cursor is invisible/unstable, uncomment:
    # WLR_NO_HARDWARE_CURSORS = "1";
  };

  # ------------------------------------------------------------
  # Optional: enable a polkit authentication agent (needed for GUI)
  # systemd.user.services.polkit-gnome-authentication-agent-1 = { ... }
  # Usually Hyprland users start it via their WM config, not here.

  # If you want to install `wl-clipboard` and `xdg-utils` system-wide:
   environment.systemPackages = with pkgs; [
  #   wl-clipboard
     xdg-utils
   ];
}