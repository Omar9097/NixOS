# modules/home/quickshell.nix
#
# Quickshell (the actual "ii" shell from dots-hyprland-main/dots/.config/quickshell/ii,
# now symlinked via dotfiles.nix) plus every dependency it and the accompanying
# hypr/*.lua config shell out to. Package choices here follow the project's own
# sdata/dist-nix/home-manager mapping (the authors' authoritative Arch -> nixpkgs
# translation), not guesses, and are deduped against what's already installed by
# your other home-manager modules (packages.nix, modules/packages/default.nix).
{ pkgs, lib, quickshell ? null, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  # ---------------------------------------------------------------------
  # Quickshell itself, wrapped with its Qt6/QML runtime deps. Adapted
  # from end-4/dots-hyprland's own sdata/dist-nix/home-manager/quickshell.nix.
  # ---------------------------------------------------------------------
  qs = quickshell.packages.${system}.default;

  quickshellWrapped = pkgs.stdenv.mkDerivation {
    name = "illogical-impulse-quickshell-wrapper";
    meta = with pkgs.lib; {
      description = "Quickshell bundled with the Qt/QML deps the ii config needs";
      license = licenses.gpl3Only;
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ pkgs.makeWrapper pkgs.qt6.wrapQtAppsHook ];

    buildInputs = with pkgs; [
      qs
      kdePackages.qtwayland
      kdePackages.qtpositioning
      kdePackages.qtlocation
      kdePackages.syntax-highlighting
      gsettings-desktop-schemas
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qt5compat
      qt6.qtimageformats
      qt6.qtmultimedia
      qt6.qtpositioning
      qt6.qtquicktimeline
      qt6.qtsensors
      qt6.qtsvg
      qt6.qttools
      qt6.qttranslations
      qt6.qtvirtualkeyboard
      qt6.qtwayland
      kdePackages.kirigami
      kdePackages.kdialog
      vulkan-headers
      libdrm
      cpptrace
      jemalloc
      mesa
    ];

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${qs}/bin/qs $out/bin/qs \
        --prefix XDG_DATA_DIRS : ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}
      chmod +x $out/bin/qs
    '';
  };

  # ---------------------------------------------------------------------
  # Two fonts with no nixpkgs package at all (confirmed via upstream's own
  # dist-nix mapping, marked TODO there too). First `home-manager switch`
  # will fail on these with a hash mismatch -- paste the real sha256 it
  # prints over each `lib.fakeSha256` below and rebuild.
  # ---------------------------------------------------------------------
  otf-space-grotesk = pkgs.stdenvNoCC.mkDerivation {
    pname = "space-grotesk";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "floriankarsten";
      repo = "space-grotesk";
      rev = "master";
      sha256 = "sha256-NvDJeIJYGn3sNGGuOLYz9jQf/NKvt8jsZdhwsliHzzM=";
    };
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      find . -iname "*.otf" -exec cp {} $out/share/fonts/opentype/ \;
    '';
  };

  ttf-readex-pro = pkgs.stdenvNoCC.mkDerivation {
    pname = "readex-pro";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "ThomasJockin";
      repo = "readexpro";
      rev = "master";
      sha256 = "sha256-+CLym2N2O6Opv7pxuVA+sfiENggPD5HRJrVByzaMMN8=";
    };
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      find . -iname "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
    '';
  };

  # materialyoucolor isn't in nixpkgs -- package it from PyPI so it can be
  # bundled into a real python.withPackages closure below. Pure Python, no
  # compiled extensions, so this is a plain buildPythonPackage.
  materialyoucolor = pkgs.python3Packages.buildPythonPackage rec {
    pname = "materialyoucolor";
    version = "2.0.9";
    format = "pyproject";
    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-J35//h3tWn20f5ej6OXaw4NKnxung9q7m0E4Zf9PUw4=";
    };
    nativeBuildInputs = [ pkgs.python3Packages.setuptools ];
    doCheck = false;
  };

  # The actual interpreter switchwall.sh's `python3 generate_colors_material.py`
  # call resolves to on PATH, with every module those color scripts import
  # baked in (Pillow, numpy, opencv4/cv2, materialyoucolor).
  iiPython = pkgs.python3.withPackages (ps: [
    ps.pillow
    ps.numpy
    ps.opencv4
    materialyoucolor
  ]);
in
{
  home.packages = with pkgs;
    [
      ### illogical-impulse-audio
      cava # NOTE: libcava is a shared library only, no CLI -- this is the actual binary
      lxqt.pavucontrol-qt
      libdbusmenu-gtk3
      playerctl

      ### illogical-impulse-backlight
      (geoclue2.override { withDemoAgent = true; })
      ddcutil

      ### illogical-impulse-basic
      bc
      cmake
      ripgrep
      jq
      xdg-user-dirs
      rsync
      yq-go

      ### illogical-impulse-bibata-modern-classic-bin
      bibata-cursors

      ### illogical-impulse-fonts-themes
      adw-gtk3
      kdePackages.breeze
      darkly
      # darkly-qt5 removed from nixpkgs (outdated KF5 dep) -- Kvantum's
      # "Colloid"/"MaterialAdw" themes (already in dotfiles/Kvantum) cover
      # the Qt side instead, so nothing else to substitute here.
      eza
      matugen
      material-symbols
      rubik
      twemoji-color-font
      otf-space-grotesk
      ttf-readex-pro

      ### illogical-impulse-hyprland
      hyprsunset

      ### illogical-impulse-kde
      kdePackages.bluedevil
      kdePackages.plasma-nm
      kdePackages.systemsettings

      ### illogical-impulse-python (used by ii's python-based widgets/venv)
      uv
      gtk4
      libadwaita
      libsoup_3
      libportal-gtk4
      gobject-introspection
      # NOTE: `uv`/the venv at ~/.local/state/quickshell/.venv are NOT what
      # actually gets used for wallpaper colors -- switchwall.sh calls
      # `python3 generate_colors_material.py` directly, bypassing that
      # script's own venv-activating shebang entirely. So the interpreter
      # that needs Pillow/materialyoucolor/opencv4/numpy importable is
      # whatever plain `python3` resolves to on PATH -- iiPython below.
      # (uv/the venv are still fine to keep around for anything else that
      # does properly activate it.)
      iiPython

      ### illogical-impulse-screencapture
      grim
      hyprshot
      slurp
      swappy
      tesseract
      wf-recorder

      ### illogical-impulse-toolkit
      upower
      wtype
      ydotool

      ### illogical-impulse-widgets
      glib
      imagemagick
      hypridle
      hyprpicker
      songrec
      translate-shell
      libqalculate
      psmisc # provides `killall`, used throughout ii's QML (mako/dunst/kded6 conflict checks)
      file # MIME-type detection for file previews
      python3Packages.kde-material-you-colors # generates the Material You colors kde-material-you-colors/config.conf points at
    ]
    ++ [ quickshellWrapped ];

  # -------------------------------------------------------------------
  # microtex-git -- LaTeX rendering in Quickshell's math/note widgets.
  # No nixpkgs package exists upstream either (also TODO in their own
  # dist-nix mapping). Skip unless you actually use that feature; ask
  # if you want me to write a derivation that installs it somewhere
  # sane instead of the hardcoded /opt/MicroTeX the Arch build expects.
  # -------------------------------------------------------------------
}
