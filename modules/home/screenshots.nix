# modules/home/screenshots.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grim
    slurp
    swappy
    jq

    (pkgs.writeShellApplication {
      name = "screenshot-menu";
      runtimeInputs = with pkgs; [ rofi grim slurp swappy wl-clipboard libnotify hyprland jq ];
      text = ''
        choice=$(printf "Full screen\nRegion\nWindow\nRegion (annotate)" | rofi -dmenu -p "Screenshot")

        case "$choice" in
          "Full screen")
            grim - | wl-copy
            notify-send "Screenshot" "Full screen copied to clipboard"
            ;;
          "Region")
            grim -g "$(slurp)" - | wl-copy
            notify-send "Screenshot" "Region copied to clipboard"
            ;;
          "Window")
            geom=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
            grim -g "$geom" - | wl-copy
            notify-send "Screenshot" "Window copied to clipboard"
            ;;
          "Region (annotate)")
            grim -g "$(slurp)" - | swappy -f -
            notify-send "Screenshot" "Saved/edited with swappy"
            ;;
          *)
            exit 0
            ;;
        esac
      '';
    })
  ];
}
