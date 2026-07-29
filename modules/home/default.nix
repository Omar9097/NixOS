# modules/home/default.nix
{ config, pkgs, username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./neovim.nix      # Neovim + its dependencies
    ./bash.nix
    ./theme.nix
    ./packages.nix    # user applications (wofi, rofi, pcmanfm, ...)
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  # Additional packages that don't fit in other modules (e.g., custom scripts)
  home.packages = with pkgs; [
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [ fzf nix-search-tv ];
      text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
    })
  ];
}