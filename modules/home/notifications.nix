# modules/home/notifications.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
