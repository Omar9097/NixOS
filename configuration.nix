# configuration.nix
{ config, lib, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/networking.nix
    ./modules/system/hardware.nix
    ./modules/system/audio.nix
    ./modules/system/display-manager.nix
    ./modules/desktop/hyprland/hyprland.nix
    ./modules/packages/default.nix
  ];

  time.timeZone = "Africa/Cairo";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # Using "unstable" because you're on nixos-unstable
  system.stateVersion = "26.05";
}
