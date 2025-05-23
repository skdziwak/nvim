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
    neovimConfigured = {
      isFull,
      extraLanguages ? {},
    }:
      inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          (import ./config.nix {
            inherit isFull;
            inherit extraLanguages;
          })
        ];
      };
  in rec {
    packages.x86_64-linux = rec {
      default = (neovimConfigured {isFull = true;}).neovim;
      min = (neovimConfigured {isFull = false;}).neovim;
      rust-min =
        (neovimConfigured {
          isFull = false;
          extraLanguages = {
            enableLSP = true;
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            rust.enable = true;
          };
        })
        .neovim;
      vscode =
        (pkgs.vscode-with-extensions.override {
          vscodeExtensions = with pkgs.vscode-extensions;
            [
              asvetliakov.vscode-neovim
              bierner.markdown-mermaid
              ms-vscode-remote.remote-ssh
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "roo-cline";
                publisher = "RooVeterinaryInc";
                version = "3.15.4";
                sha256 = "sha256-4YZgIUZdtD/EKc6b76J8WfTD/QRyvqPSDDdk8kMKdD0=";
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
