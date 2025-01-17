{
  description = "Neovim configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };
  outputs = {
    self,
    nixpkgs,
    nvf,
  } @ inputs: let
    neovimConfigured = inputs.nvf.lib.neovimConfiguration {
      inherit (nixpkgs.legacyPackages.x86_64-linux) pkgs;
      modules = [
        ./config.nix
      ];
    };
  in {
    packages.x86_64-linux = {
      default = neovimConfigured.neovim;
    };
    nixosModule = import ./nixosModule.nix {
      inherit neovimConfigured;
    };
  };
}
