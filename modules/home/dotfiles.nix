# modules/home/dotfiles.nix
{ config, ... }:
let
  dotfilesRoot = ./dotfiles;   # points to modules/home/dotfiles/
  link = path: config.lib.file.mkOutOfStoreSymlink path;
  apps = [ "foot" "hypr" "nvim" "rofi" "waybar" /*"wofi"*/ ];
in
{
  xdg.configFile = builtins.listToAttrs (map (name: {
    name = name;
    value.source = link "${dotfilesRoot}/${name}";
  }) apps);
}