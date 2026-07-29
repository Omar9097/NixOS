{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    htop
    pciutils
    vim
    tree
    nix-tree
    man-pages
    man-pages-posix
  ];
}