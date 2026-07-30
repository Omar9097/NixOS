{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config#Blue";
      vi = "nvim";
      vim = "nvim";
    };

    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
      nitch
      
      ds4color() {
        local target="*" r g b
        if [ "$#" -ge 4 ]; then
          # 4 arguments: ds4color <input_num> <R> <G> <B>
          target="input$1"
          r=$2; g=$3; b=$4
        else
          # 1 to 3 arguments: ds4color <R> <G> <B>
          r=''${1:-255}; g=''${2:-0}; b=''${3:-255}
        fi

        echo "$r" | sudo tee /sys/class/leds/$target:red/brightness > /dev/null
        echo "$g" | sudo tee /sys/class/leds/$target:green/brightness > /dev/null
        echo "$b" | sudo tee /sys/class/leds/$target:blue/brightness > /dev/null
      }
    '';
  };
}
