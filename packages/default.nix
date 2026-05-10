{ inputs, pkgs }:
let
  inherit (pkgs) lib;
  nixporn = import ../nixporn {
    inherit inputs lib;
  };

  defaultVariant =
    name:
    let
      meta = nixporn.colorschemeMeta.${name};
    in
    if meta.defaultVariant == null then "default" else meta.defaultVariant;

  defaultPalette =
    name:
    let
      variant = defaultVariant name;
    in
    if variant == "default" then
      nixporn.palettes.${name}.default or nixporn.palettes.${name}
    else
      nixporn.palettes.${name}.${variant};

  cursorColors =
    palette:
    let
      base = palette.base or palette;
    in
    if palette ? cursor && builtins.isAttrs palette.cursor then
      palette.cursor
    else
      {
        baseColor = base.blue;
        outlineColor = base.bg_highlight;
        watchBackgroundColor = base.orange;
      };

  cursorThemeName = name: variant: "Bibata-${name}-${variant}";

  mkXcursor =
    name:
    let
      variant = defaultVariant name;
    in
    import ./bibata-xcursor.nix (
      {
        inherit (pkgs)
          clickgen
          fetchFromGitHub
          lib
          resvg
          stdenvNoCC
          ;
        cursorThemeName = cursorThemeName name variant;
      }
      // cursorColors (defaultPalette name)
    );

  mkHyprcursor =
    name:
    let
      variant = defaultVariant name;
    in
    import ./bibata-hyprcursor.nix (
      {
        inherit (pkgs)
          fetchFromGitHub
          hyprcursor
          lib
          python3
          stdenvNoCC
          ;
        inherit (pkgs) python3Packages;
        cursorThemeName = "${cursorThemeName name variant}-Hyprcursor";
      }
      // cursorColors (defaultPalette name)
    );

  cursorPackages = lib.pipe nixporn.supportedColorschemes [
    (builtins.map (name: {
      "${name}-xcursor" = mkXcursor name;
      "${name}-hyprcursor" = mkHyprcursor name;
    }))
    (builtins.foldl' (acc: value: acc // value) { })
  ];

  packages = {
    catppuccin = import ./catppuccin.nix {
      inherit pkgs;
      src = inputs.catppuccin-palette;
    };
    cyberdream = import ./cyberdream.nix {
      inherit pkgs;
      src = inputs.cyberdream;
    };
    decay = import ./decay.nix {
      inherit pkgs;
      src = inputs.decay;
    };
    dracula = import ./dracula.nix {
      inherit pkgs;
      src = inputs.dracula;
    };
    gruvbox = import ./gruvbox.nix {
      inherit pkgs;
      src = inputs.gruvbox;
    };
    kanagawa = import ./kanagawa.nix {
      inherit pkgs;
      src = inputs.kanagawa;
    };
    nordic = import ./nordic.nix {
      inherit pkgs;
      src = inputs.nordic;
    };
    "rose-pine" = import ./rose-pine.nix {
      inherit pkgs;
      src = inputs."rose-pine";
    };
    "solarized-osaka" = import ./solarized-osaka.nix {
      inherit pkgs;
      src = inputs."solarized-osaka";
    };
    tokyonight = import ./tokyonight.nix {
      inherit pkgs;
      src = inputs.tokyonight;
      spotifySrc = inputs.tokyonight-spotify;
    };
  };
in
packages // cursorPackages // {
  default = packages.catppuccin;
}
