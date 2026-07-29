# modules/home/neovim.nix
{ pkgs, ... }:
{
  # Neovim with vi/vim aliases
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  # All packages Neovim expects to find at runtime
  home.packages = with pkgs; [
    # Searching & fuzzy finding (Telescope, etc.)
    ripgrep
    fd
    fzf

    # Language servers & formatters
    nil                 # Nix LSP
    nixpkgs-fmt         # Nix formatter
    lua-language-server # Lua LSP

    # Build tools (some LSPs need Node, C compiler, etc.)
    nodejs
    gcc
  ];
}