# modules/home/theme.nix
# Home Manager module – consistent GTK, icon, and cursor theme.
# All theming is set here, no need to export GTK_THEME etc. from Hyprland.
{ config, pkgs, ... }:
{
  # Packages required for the themes
  home.packages = with pkgs; [
    tokyonight-gtk-theme      # Tokyo Night GTK theme (dark variant)
    adwaita-icon-theme        # icon theme
    gnome-themes-extra        # needed for some theme engines
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyo-Night-Dark";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    # Optional: enable dark mode globally
    # gtk.gtk3.extraCss = ...
    # gtk.gtk4.extraCss = ...
  };

  # Environment variables (needed by some toolkits, Flatpaks, etc.)
  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    # GTK_THEME is intentionally not set – the gtk module writes
    # ~/.config/gtk-3.0/settings.ini and ~/.config/gtk-4.0/settings.ini
    # which are respected by GTK apps.
  };
}