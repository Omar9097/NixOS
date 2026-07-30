# modules/home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ---- Terminals ----
    foot # Wayland-native (foot.ini)
    kitty # alternative terminal

    # ---- Hyprland desktop essentials ----
    waybar # status bar
    hyprpaper # wallpaper daemon
    rofi # app launcher (config in dotfiles)
    mako # notification daemon
    swaylock-effects # lock screen
    libnotify

    # ---- File manager ----
    pcmanfm
    yazi
    hyprpolkitagent

    # ---- Daily tools ----
    vim # fallback editor
    wget
    git

    # ---- Media ----
    mpv
    pavucontrol

    # ---- Eye candy ----
    nitch

    # ---- Web browser ----
    firefox

    # ---- Fonts (for foot terminal & general use) ----
    nerd-fonts.jetbrains-mono

    # ---- Archive tools ----
    unzip
    unrar
    p7zip

    # ---- Optional ----
    imv # image viewer
    zathura # PDF viewer
  ];
}
