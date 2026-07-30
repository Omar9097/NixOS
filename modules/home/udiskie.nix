# modules/home/udiskie.nix
{ ... }:
{
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true; # will actually show now that libnotify is installed
  };
}
