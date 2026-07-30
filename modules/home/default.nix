# modules/home/default.nix
{ config, pkgs, username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./neovim.nix # Neovim + its dependencies
    ./bash.nix
    ./theme.nix
    ./packages.nix # user applications (wofi, rofi, pcmanfm, ...)
    ./notifications.nix # volume-notify, brightness-notify
    ./screenshots.nix # screenshot-menu + grim/slurp/swappy/jq
    ./clipboard.nix # cliphist clipboard history
    ./udiskie.nix
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
