{
  description = "NixOS Flake Configuration for Dell Inspiron 5593";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, quickshell, ... }:
  let
    system = "x86_64-linux";
    username = "omar";
  in {
    nixosConfigurations.Blue = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit username; };

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        # Intel CPU & chipset
        nixos-hardware.nixosModules.common-cpu-intel
        # Laptop power & ACPI
        nixos-hardware.nixosModules.common-pc-laptop
        # SSD TRIM
        nixos-hardware.nixosModules.common-pc-ssd

        # Nvidia Optimus (Intel + Nvidia)
        nixos-hardware.nixosModules.common-gpu-nvidia

        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./modules/home;   # ← updated path
            extraSpecialArgs = { inherit username quickshell; };
            backupFileExtension = "backup";              # ← typo fixed
          };
        }
      ];
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
  };
}
