# modules/home/dotfiles.nix
{ config, ... }:
let
  dotfilesRoot = "/home/omar/nixos-config/modules/home/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
  apps = [
    "foot" "hypr" "nvim" "yazi"                       # kept from before
    "quickshell" "fuzzel" "kitty" "matugen" "wlogout"  # new: ii shell + companions
    "mpv" "kde-material-you-colors" "Kvantum" "fish" "xdg-desktop-portal"
    # "fontconfig" handled separately below -- whole-dir symlink conflicts
    # with home-manager's own generated conf.d/10-hm-fonts.conf
    # "waybar" "rofi" "mako" -> removed, replaced by the Quickshell (ii) shell
  ];
in
{
  xdg.configFile = builtins.listToAttrs (map
    (name: {
      name = name;
      value.source = link "${dotfilesRoot}/${name}";
    })
    apps)
  // {
    "fontconfig/fonts.conf".source = link "${dotfilesRoot}/fontconfig/fonts.conf";
  };
}
