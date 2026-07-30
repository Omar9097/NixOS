# modules/home/clipboard.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cliphist
    wl-clipboard
  ];
}
