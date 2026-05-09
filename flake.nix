{
  description = "Reusable preset colorscheme modules for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin-palette = {
      url = "github:catppuccin/palette";
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

    dracula = {
      url = "github:dracula/dracula-theme";
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

    gruvbox = {
      url = "github:morhetz/gruvbox";
      flake = false;
    };

    kanagawa = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };

    nordic = {
      url = "github:AlexvZyl/nordic.nvim";
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
          nixporn = import ./nixporn { lib = final; };
        }
      );
      mkColorschemeModule = import ./modules/colorscheme;
      mkHomeColorschemeModule = import ./modules/home { inherit inputs; };
    in
    {
      inherit lib;

      nixosModules.default = self.nixosModules.colorscheme;
      nixosModules.colorscheme = mkColorschemeModule;

      homeModules.default = self.homeModules.colorscheme;
      homeModules.colorscheme = mkHomeColorschemeModule;

      darwinModules.default = self.darwinModules.colorscheme;
      darwinModules.colorscheme = mkColorschemeModule;
    };
}
