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
    kdePackages.dolphin      # Dolphin file manager
    kdePackages.kio          # required since NixOS 25.11 for Dolphin's core functionality
    kdePackages.kio-extras   # extra protocol support (sftp, etc.)
    kdePackages.breeze-icons # icon set so Dolphin doesn't show blank icons
    hyprpolkitagent

    # ---- Daily tools ----
    vim # fallback editor
    wget
    git

    # ---- Media ----
    mpv
    pavucontrol
    starship      # required by yazi's starship.yazi plugin
    mediainfo     # required by yazi's mediainfo.yazi plugin (media previews)

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
