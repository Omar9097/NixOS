# modules/home/dotfiles.nix
{ config, ... }:
let
  dotfilesRoot = "/home/omar/nixos-config/modules/home/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
  apps = [ "foot" "hypr" "nvim" "rofi" "waybar" "yazi" "mako" /*"wofi"*/ ];
in
{
  xdg.configFile = builtins.listToAttrs (map
    (name: {
      name = name;
      value.source = link "${dotfilesRoot}/${name}";
    })
    apps);
}
