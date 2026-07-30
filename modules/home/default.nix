# modules/home/default.nix
{ config, pkgs, username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./neovim.nix # Neovim + its dependencies
    ./bash.nix
    ./theme.nix
    ./packages.nix # user applications (wofi, rofi, pcmanfm, ...)
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  # Git
  programs.git = {
    enable = true;
    userName = "Omar9097";
    userEmail = "oelnaggar114@gmaail.com";
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
  home.packages = with pkgs;
    [
      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [ fzf nix-search-tv ];
        text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
      })

      (pkgs.writeShellApplication {
        name = "volume-notify";
        runtimeInputs = with pkgs; [ wireplumber libnotify gawk gnugrep ];
        text = ''
          case "$1" in
            up) wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ ;;
            down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
            mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
          esac

          vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
          pct=$(echo "$vol" | awk '{printf "%d", $2*100}')

          if echo "$vol" | grep -q MUTED; then
            notify-send -h string:x-canonical-private-synchronous:volume -t 1500 "Volume" "Muted"
          else
            notify-send -h string:x-canonical-private-synchronous:volume -h int:value:"$pct" -t 1500 "Volume" "''${pct}%"
          fi
        '';
      })

      (pkgs.writeShellApplication {
        name = "brightness-notify";
        runtimeInputs = with pkgs; [ brightnessctl libnotify gawk ];
        text = ''
          case "$1" in
            up) brightnessctl set 5%+ ;;
            down) brightnessctl set 5%- ;;
          esac

          pct=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')
          notify-send -h string:x-canonical-private-synchronous:brightness -h int:value:"$pct" -t 1500 "Brightness" "''${pct}%"
        '';
      })
    ];

}

