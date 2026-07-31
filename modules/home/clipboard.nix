# modules/home/clipboard.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cliphist
    wl-clipboard
    libnotify

    (pkgs.writeShellApplication {
      name = "clipboard-menu";
      runtimeInputs = with pkgs; [ cliphist rofi wl-clipboard coreutils gnugrep imagemagick ];
      text = ''
        cache_dir="$HOME/.cache/cliphist-thumbs"
        mkdir -p "$cache_dir"

        # A truly transparent 1x1 PNG, used as a placeholder "icon" for
        # text entries so every row (text or image) has an icon field —
        # keeps rofi's layout consistent/centered across all rows.
        blank="$cache_dir/blank.png"
        if [ ! -f "$blank" ]; then
          magick -size 1x1 xc:none "$blank"
        fi

        # -preview-width controls how many characters of text entries are
        # shown before truncation (cliphist's own default is only 100).
        mapfile -t lines < <(cliphist -preview-width 300 list)

        # Uses rofi's row INDEX (not the displayed text) to identify the
        # selection, so we can strip the "<id>\t" prefix from every entry
        # (text and image alike) and just show clean content.
        chosen_index=$(
          for line in "''${lines[@]}"; do
            content=$(printf '%s' "$line" | cut -f2-)
            if echo "$line" | grep -q "binary data"; then
              id=$(printf '%s' "$line" | cut -f1)
              thumb="$cache_dir/$id.png"
              if [ ! -f "$thumb" ]; then
                printf '%s\n' "$line" | cliphist decode > "$thumb" 2>/dev/null || true
              fi
              printf ' \0icon\x1f%s\n' "$thumb"
            else
              printf '%s\0icon\x1f%s\n' "$content" "$blank"
            fi
          done | rofi -dmenu -show-icons -p "Clipboard" -theme ~/.config/rofi/clipboard.rasi -format i
        )

        [ -z "$chosen_index" ] && exit 0

        selected_line="''${lines[$chosen_index]}"
        echo "$selected_line" | cliphist decode | wl-copy
      '';
    })

    (pkgs.writeShellApplication {
      name = "clipboard-wipe";
      runtimeInputs = with pkgs; [ cliphist libnotify ];
      text = ''
        rm -rf "$HOME/.cache/cliphist-thumbs"
        cliphist wipe
        notify-send "Clipboard" "History cleared"
      '';
    })
  ];
}
