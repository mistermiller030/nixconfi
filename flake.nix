{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    inputs.disko.url = "github:nix-community/disko";
    inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./systems/x86_64-linux/nixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
      nixosConfigurations.hetzner1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./systems/x86_64-linux/hetzner1/configuration.nix
        ];
      };

    };
}
