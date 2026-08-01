# modules/home/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ---- Terminals ----
    foot # Wayland-native (foot.ini)
    kitty # alternative terminal
    fish # foot's config (from ii dotfiles) uses this as its shell

    # ---- Hyprland desktop essentials ----
    fuzzel # fallback launcher/clipboard-picker when Quickshell isn't running
    hyprlock # lock screen (config comes from dotfiles/hypr)
    libnotify

    # ---- ii shell runtime bits called directly from hypr/execs.lua & keybinds.lua ----
    gnome-keyring # `gnome-keyring-daemon` is exec'd directly, not just via the system service
    easyeffects # `easyeffects --hide-window --service-mode` autostart
    wl-clipboard
    cliphist

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
