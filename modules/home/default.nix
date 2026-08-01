# modules/home/default.nix
{ config, pkgs, username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./neovim.nix # Neovim + its dependencies
    ./bash.nix
    #    ./theme.nix
    ./packages.nix # user applications (kitty, dolphin, pcmanfm, ...)
    # ./notifications.nix  # superseded: ii's Quickshell shell has its own OSDs for volume/brightness
    # ./screenshots.nix    # superseded: ii binds Print/region-shot/OCR straight to grim/slurp/tesseract + its own overview UI
    # ./clipboard.nix      # superseded: ii's Cliphist.qml service + SUPER+V overview handle clipboard history
    ./udiskie.nix
    ./gaming-home.nix
    ./quickshell.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  # Git
  programs.git = {
    enable = true;
    userName = "Omar9097";
    userEmail = "oelnaggar114@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  # ssh
  programs.ssh =
    {
      enable = true;
      addKeysToAgent = "yes";
    };

  # Misc custom scripts
  home.packages = with pkgs;
    [
      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [ fzf nix-search-tv ];
        text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
      })
    ];
}
