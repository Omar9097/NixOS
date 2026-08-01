{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
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
    brightnessctl
    ntfs3g
  ];

  fonts.packages = with pkgs; [
    material-symbols
    nerd-fonts.jetbrains-mono
    rubik
    google-fonts # Pulls in Readex Pro, Space Grotesk, and other Google fonts
  ];

}

