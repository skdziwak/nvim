{
  description = "Neovim configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };
  outputs = {
    nixpkgs,
    nvf,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    neovimConfigured = {isFull}:
      inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
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
      neovimConfigured = neovimConfigured {isFull = true;};
    };
  };
}
