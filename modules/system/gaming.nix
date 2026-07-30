# modules/system/gaming.nix
{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;      # for streaming to other devices
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;      # optional: run games in a gamescope session
  };

  # Feral GameMode – dynamically requests performance governor while gaming
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud   # in-game FPS/perf overlay
  ];
}
