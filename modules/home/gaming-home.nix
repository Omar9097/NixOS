# modules/home/gaming.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (bottles.override { removeWarningPopup = true; })  # Wine prefix manager for Windows apps/games
    lutris        # game library / launcher, manages Wine + native games
    protonup-qt   # installs/manages GE-Proton versions for Steam & Lutris
  ];
}
