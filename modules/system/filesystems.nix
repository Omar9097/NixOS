# modules/system/filesystems.nix
{ ... }:
{
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/7E10685A10681B81";
    fsType = "ntfs-3g";
    options = [ "defaults" "uid=1000" "gid=100" "umask=022" "nofail" ];
  };
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true; # lets pcmanfm see/browse removable drives
}
