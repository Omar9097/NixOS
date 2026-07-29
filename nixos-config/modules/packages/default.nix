# modules/packages/default.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Basic CLI tools (available to all users / root)
    htop
    curl
    wget
    git
    pciutils
    unzip
    vim   # or just keep nano
    # ...
  ];
}