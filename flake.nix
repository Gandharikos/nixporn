{
  description = "Reusable preset colorscheme modules for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin-palette = {
      url = "github:catppuccin/palette";
      flake = false;
    };

    cyberdream = {
      url = "github:scottmckendry/cyberdream.nvim";
      flake = false;
    };

    decay = {
      url = "github:decaycs/decay.nvim";
      flake = false;
    };

    dracula = {
      url = "github:Mofiqul/dracula.nvim";
      flake = false;
    };

    gruvbox = {
      url = "github:morhetz/gruvbox";
      flake = false;
    };

    kanagawa = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };

    nordic = {
      url = "github:andersevenrud/nordic.nvim";
      flake = false;
    };

    rose-pine = {
      url = "github:rose-pine/neovim";
      flake = false;
    };

    solarized-osaka = {
      url = "github:craftzdog/solarized-osaka.nvim";
      flake = false;
    };

    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    tokyonight-spotify = {
      url = "github:evening-hs/Spotify-Tokyo-Night-Theme";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      lib = nixpkgs.lib.extend (
        final: _: {
          nixporn = import ./nixporn {
            inherit inputs;
            lib = final;
          };
        }
      );
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      inherit lib;

      packages = forAllSystems (
        system:
        import ./packages {
          inherit inputs;
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );

      nixosModules.default = self.nixosModules.colorscheme;
      nixosModules.colorscheme = lib.nixporn.mkColorschemeModule;

      homeModules.default = self.homeModules.colorscheme;
      homeModules.colorscheme = lib.nixporn.mkHomeColorschemeModule;

      darwinModules.default = self.darwinModules.colorscheme;
      darwinModules.colorscheme = lib.nixporn.mkColorschemeModule;
    };
}
