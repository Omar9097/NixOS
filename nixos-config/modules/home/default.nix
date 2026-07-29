# modules/home/dotfiles.nix
{ config, ... }:
let
  # All directories under ./dotfiles that you want linked to ~/.config
  configDirs = [
    "foot"
    "hypr"
    "nvim"
    "rofi"
    "waybar"
  ];

  dotfilesRoot = ./dotfiles;
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  xdg.configFile = builtins.listToAttrs (map (name: {
    name = name;
    value = {
      source = link "${dotfilesRoot}/${name}";
    };
  }) configDirs);
}