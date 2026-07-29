{ ... }:
{
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = false;
    wireplumber.enable = true;
  };
}