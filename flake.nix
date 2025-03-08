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
  in rec {
    packages.x86_64-linux = rec {
      default = (neovimConfigured {isFull = true;}).neovim;
      min = (neovimConfigured {isFull = false;}).neovim;
      vscode =
        (pkgs.vscode-with-extensions.override {
          vscodeExtensions = with pkgs.vscode-extensions;
            [
              asvetliakov.vscode-neovim
              bierner.markdown-mermaid
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "roo-cline";
                publisher = "RooVeterinaryInc";
                version = "3.7.11";
                sha256 = "sha256-y7Mjst6CeEOpjk1bHSFpTVAQeZzb2gFMZ8dtPRSbUbs=";
              }
            ];
        })
        .overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [default];
        });
    };
    nixosModule = import ./nixosModule.nix {
      neovimConfigured = neovimConfigured {isFull = true;};
      inherit (packages.x86_64-linux) vscode;
    };
  };
}
