# modules/home/neovim.nix
{ pkgs, ... }:
{
  # All packages Neovim expects to find at runtime
  home.packages = with pkgs; [
    neovim
    tree-sitter
    # Searching & fuzzy finding (Telescope, etc.)
    ripgrep
    fd
    fzf

    # Language servers & formatters
    nil # Nix LSP
    nixpkgs-fmt # Nix formatter
    lua-language-server # Lua LSP

    # Build tools (some LSPs need Node, C compiler, etc.)
    nodejs
    gcc
  ];
}

