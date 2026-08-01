# modules/home/dotfiles.nix
{ config, lib, ... }:
let
  dotfilesRoot = "/home/omar/nixos-config/modules/home/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  # Auto-discover every top-level entry in dotfiles/ instead of a
  # hand-maintained list -- add/remove a folder there and it's picked
  # up on the next rebuild automatically.
  #
  # NOTE: we read the *relative* path here (./dotfiles, which Nix copies
  # into the flake's own store input and can read purely) just to get the
  # names. The actual symlinks below still point at the absolute
  # out-of-store path, so editing a dotfile doesn't require a rebuild.
  entries = builtins.readDir ./dotfiles;
  names = builtins.attrNames entries;

  # fontconfig needs special handling: home-manager writes its own
  # conf.d/10-hm-fonts.conf inside ~/.config/fontconfig, so we can't
  # symlink that whole directory -- just the one file ii ships.
  skipWholeDir = [ "fontconfig" ];
  autoApps = builtins.filter (n: !(builtins.elem n skipWholeDir)) names;
in
{
  xdg.configFile = builtins.listToAttrs (map
    (name: {
      inherit name;
      value.source = link "${dotfilesRoot}/${name}";
    })
    autoApps)
  // {
    "fontconfig/fonts.conf".source = link "${dotfilesRoot}/fontconfig/fonts.conf";
  };
}
