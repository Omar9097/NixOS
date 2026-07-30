# modules/home/theme.nix
# Home Manager module – consistent GTK, Qt, icon, and cursor theme, dark mode everywhere.
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
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt apps (Dolphin, etc.) follow their own theming system, separate from GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk3";   # makes Qt apps match your GTK theme instead of default Breeze
    style.name = "adwaita-dark";
  };

  # Tells apps that use the xdg-desktop-portal "Settings" API (Firefox, some
  # GTK4/libadwaita apps) to prefer dark mode, independent of the GTK theme name.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
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
