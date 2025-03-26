{
  description = "Neovim configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    nvf,
    self,
    ...
  } @ inputs: let
    # Define supported systems
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Helper function to generate attributes for each system
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

    # Generate packages for each system
    neovimConfigured = system: {isFull}: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in
      inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [(import ./config.nix {inherit isFull;})];
      };
  in {
    packages = forAllSystems (
      system: let
        nvimConfig = neovimConfigured system;
      in {
        default = (nvimConfig {isFull = true;}).neovim;
        min = (nvimConfig {isFull = false;}).neovim;

        # VSCode is currently only supported on Linux
        # You may want to add conditions for other platforms
        vscode = nixpkgs.lib.optionalAttrs (builtins.match ".*-linux" system != null) (
          let
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
                allowUnfreePredicate = _: true;
              };
            };
          in
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
              buildInputs = old.buildInputs ++ [(nvimConfig {isFull = true;}).neovim];
            })
        );
      }
    );

    # NixOS module (currently for Linux only, but can be expanded)
    nixosModule = {
      x86_64-linux = import ./nixosModule.nix {
        neovimConfigured = neovimConfigured "x86_64-linux" {isFull = true;};
        inherit (nixpkgs.lib.getAttrFromPath ["packages" "x86_64-linux" "vscode"] self) vscode;
      };
      # Add other platforms as needed
    };
  };
}
