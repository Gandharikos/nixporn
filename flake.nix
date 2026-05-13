{
  description = "Reusable preset colorscheme modules for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = lib.systems.flakeExposed;
      devSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs systems;
      forAllDevSystems = lib.genAttrs devSystems;

      nixporn = import ./nixporn { inherit lib; };

      mkModule =
        {
          name ? "colorscheme",
          type,
          file,
        }:
        { ... }:
        {
          _file = "${self.outPath}/flake.nix#${type}Modules.${name}";

          imports = [ file ];
        };
    in
    {
      lib.nixporn = nixporn;

      packages = forAllSystems (
        system:
        (import ./default.nix {
          inherit system;
          pkgs = nixpkgs.legacyPackages.${system};
        }).packages
      );

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

      formatter = forAllDevSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.treefmt.withConfig {
          runtimeInputs = with pkgs; [
            keep-sorted
            nixfmt
          ];

          settings = {
            on-unmatched = "info";
            tree-root-file = "flake.nix";

            formatter = {
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
        }
      );

      nixosModules = {
        default = self.nixosModules.colorscheme;
        colorscheme = mkModule {
          type = "nixos";
          file = ./nixporn/module.nix;
        };
      };

      homeModules = {
        default = self.homeModules.colorscheme;
        colorscheme = mkModule {
          type = "home";
          file = ./modules;
        };
      };

      darwinModules = {
        default = self.darwinModules.colorscheme;
        colorscheme = mkModule {
          type = "darwin";
          file = ./nixporn/module.nix;
        };
      };
    };
}
