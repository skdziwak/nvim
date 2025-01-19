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
    neovimConfigured = {isFull}:
      inputs.nvf.lib.neovimConfiguration {
        inherit (nixpkgs.legacyPackages.x86_64-linux) pkgs;
        modules = [
          (import ./config.nix {inherit isFull;})
        ];
      };
  in {
    packages.x86_64-linux = {
      default = (neovimConfigured {isFull = true;}).neovim;
      min = (neovimConfigured {isFull = false;}).neovim;
    };
    nixosModule = import ./nixosModule.nix {
      inherit neovimConfigured;
    };
  };
}
