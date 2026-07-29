# modules/system/display-manager.nix
{ config, pkgs, lib, ... }:
let
  # Choose your display manager here (only one should be enabled)
  dm = "ly";   # options: "ly", "sddm", "lightdm"
in
{
  # ============================================================
  # Ly – lightweight TUI display manager
  # ============================================================
  services.displayManager.ly = lib.mkIf (dm == "ly") {
    enable = true;
  };

  # ============================================================
  # SDDM – graphical login manager (Qt-based)
  # ============================================================
  services.displayManager.sddm = lib.mkIf (dm == "sddm") {
    enable = true;
    wayland.enable = true;                     # run SDDM itself on Wayland
    theme = "chili";
    extraPackages = [ pkgs.sddm-chili ];       # provides the chili theme
  };

  # ============================================================
  # LightDM – lightweight display manager (X11 based)
  # ============================================================
  services.xserver.displayManager.lightdm = lib.mkIf (dm == "lightdm") {
    enable = true;
    greeters.gtk.enable = true;                # uses lightdm-gtk-greeter
  };

  # LightDM requires the X server to be enabled
  services.xserver.enable = lib.mkIf (dm == "lightdm") true;
}