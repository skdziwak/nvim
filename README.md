# Neovim Configuration Flake

This repository contains a Nix flake for configuring Neovim. It uses the `nvf`
library to manage Neovim configurations.

## Description

The flake provides a customizable Neovim setup with options for a full or
minimal configuration. It also includes a NixOS module for integrating the
Neovim configuration into a NixOS system.

## Structure

- **flake.nix**: The main flake file defining inputs, outputs, and
  configurations.
- **config.nix**: Contains the specific Neovim configuration modules.
- **nixosModule.nix**: Defines the NixOS module for integrating the Neovim
  configuration.

## Usage

### Inputs

- `nixpkgs`: Points to the NixOS unstable channel.
- `nvf`: Points to the `nvf` library on GitHub.

### Outputs

- **Packages**:
  - `default`: Full Neovim configuration.
  - `min`: Minimal Neovim configuration.
- **NixOS Module**: Imports the Neovim configuration for NixOS.

## Usage

### Nix Run

You can try it out with the following command:

```bash
nix run github:skdziwak/nvim
```

To run a minimal configuration, use:

```bash
nix run github:skdziwak/nvim#min
```

### Docker

If you do not have Nix installed, you can run it with docker:

```bash
docker run --rm -it \
  -v "$(pwd):/workspace" \
  -w /workspace \
  docker.io/nixos/nix \
  nix --extra-experimental-features "flakes nix-command" run github:skdziwak/nvim --
```

This is only for testing purposes. It does not cache dependencies and will
re-download them every time you recreate the container.

### NixOS Module

To use the configuration in your system, you can import it as NixOS module:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-nvim.url = "github:skdziwak/nvim";
  };

  outputs = {
    nixpkgs,
    my-nvim,
    ...
  }: {
    nixosConfigurations = {
      beelink = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          my-nvim.nixosModule
          ./configuration.nix
        ];
      };
    };
  };
}
```

## License

This project is licensed under the MIT License.
