{
  description = "Reusable preset colorscheme modules for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib.extend (
        final: _: {
          nixporn = import ./lib { lib = final; };
        }
      );

      systems = lib.systems.flakeExposed;
      devSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs systems;
      forAllDevSystems = lib.genAttrs devSystems;

      mkModule =
        {
          name ? "colorscheme",
          type,
          file,
        }:
        { ... }:
        {
          _file = "${self.outPath}/flake.nix#${type}Modules.${name}";

          imports = [
            (import file {
              moduleLib = lib;
              moduleType = type;
            })
          ];
        };

      mkFormatter =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.treefmt.withConfig {
          runtimeInputs = with pkgs; [
            deadnix
            keep-sorted
            nixfmt
          ];

          settings = {
            on-unmatched = "info";
            tree-root-file = "flake.nix";

            formatter = {
              deadnix = {
                command = "deadnix";
                options = [ "--edit" ];
                includes = [ "*.nix" ];
                priority = 1;
              };
              keep-sorted = {
                command = "keep-sorted";
                includes = [ "*" ];
              };
              nixfmt = {
                command = "nixfmt";
                includes = [ "*.nix" ];
              };
            };
          };
        };

    in
    {
      inherit lib;

      packages = forAllSystems (
        system:
        (import ./default.nix {
          inherit system;
          pkgs = nixpkgs.legacyPackages.${system};
        }).packages
      );

      overlays = {
        default = final: _: {
          inherit
            (import ./default.nix {
              pkgs = final;
              inherit (final) lib;
            })
            nixporn
            ;
        };
      };

      devShells = forAllDevSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        lib.genAttrs
          [
            "default"
            "ci"
          ]
          (
            name:
            import ./shell.nix {
              inherit pkgs;
              minimal = name == "ci";
            }
          )
      );

      formatter = forAllDevSystems mkFormatter;

      nixosModules = {
        default = self.nixosModules.colorscheme;
        nixporn = self.nixosModules.colorscheme;
        colorscheme = mkModule {
          type = "nixos";
          file = ./modules;
        };
      };

      homeModules = {
        default = self.homeModules.colorscheme;
        nixporn = self.homeModules.colorscheme;
        colorscheme = mkModule {
          type = "home";
          file = ./modules;
        };
      };

      homeManagerModules = {
        default = self.homeModules.colorscheme;
        nixporn = self.homeModules.colorscheme;
        colorscheme = self.homeModules.colorscheme;
      };

      darwinModules = {
        default = self.darwinModules.colorscheme;
        nixporn = self.darwinModules.colorscheme;
        colorscheme = mkModule {
          type = "darwin";
          file = ./modules;
        };
      };
    };
}
