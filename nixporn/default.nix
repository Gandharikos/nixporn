{ lib }:
let
  inherit (lib.attrsets) genAttrs mapAttrs;
  inherit (lib.modules) mkDefault mkIf mkMerge;

  helpers = import ../lib { inherit lib; };
  colorschemes = import ./colorschemes { inherit lib; };
  palettes = import ./palettes.nix { inherit lib; };

  supportedColorschemes = [
    "catppuccin"
    "cyberdream"
    "decay"
    "dracula"
    "gruvbox"
    "kanagawa"
    "nordic"
    "rose-pine"
    "solarized-osaka"
    "tokyonight"
  ];

  targetNames = import ./target-names.nix;

  presetArgs = {
    inherit
      helpers
      lib
      palettes
      ;
  };

  presets = mapAttrs (name: definition: definition // { options = colorschemes.${name}; }) (
    genAttrs supportedColorschemes (name: import ./presets/${name}.nix presetArgs)
  );

  options = import ./options.nix {
    inherit
      colorschemes
      lib
      supportedColorschemes
      targetNames
      ;
  };

  colorschemeMeta = {
    catppuccin = {
      variantOption = "flavor";
      variants = [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      defaultVariant = "mocha";
      accents = [
        "blue"
        "flamingo"
        "green"
        "lavender"
        "maroon"
        "mauve"
        "peach"
        "pink"
        "red"
        "rosewater"
        "sapphire"
        "sky"
        "teal"
        "yellow"
      ];
      defaultAccent = "mauve";
    };
    cyberdream = {
      variantOption = "variant";
      variants = [
        "default"
        "light"
      ];
      defaultVariant = "default";
    };
    decay = {
      variantOption = "variant";
      variants = [
        "default"
        "dark"
        "decayce"
        "cosmic"
        "light"
      ];
      defaultVariant = "default";
    };
    dracula = {
      variantOption = null;
      variants = [ ];
      defaultVariant = null;
    };
    gruvbox = {
      variantOption = "variant";
      variants = [
        "dark"
        "light"
      ];
      defaultVariant = "dark";
    };
    kanagawa = {
      variantOption = "variant";
      variants = [
        "wave"
        "dragon"
        "lotus"
      ];
      defaultVariant = "wave";
    };
    nordic = {
      variantOption = null;
      variants = [ ];
      defaultVariant = null;
    };
    "rose-pine" = {
      variantOption = "variant";
      variants = [
        "main"
        "moon"
        "dawn"
      ];
      defaultVariant = "main";
    };
    "solarized-osaka" = {
      variantOption = "variant";
      variants = [
        "dark"
        "light"
      ];
      defaultVariant = "dark";
    };
    tokyonight = {
      variantOption = "style";
      variants = [
        "storm"
        "night"
        "moon"
        "day"
      ];
      defaultVariant = "moon";
    };
  };

  getVariant =
    cfg: colorschemeName:
    let
      meta = colorschemeMeta.${colorschemeName};
    in
    if meta.variants == [ ] then
      null
    else if cfg.colorscheme.variant != null then
      cfg.colorscheme.variant
    else
      meta.defaultVariant;

  getAccent =
    cfg: colorschemeName:
    let
      meta = colorschemeMeta.${colorschemeName};
    in
    if !(meta ? accents) then
      null
    else if cfg.colorscheme.accent != null then
      cfg.colorscheme.accent
    else
      meta.defaultAccent;

  mkSelectedColorschemeConfig =
    cfg:
    let
      variant = getVariant cfg cfg.colorscheme.name;
      accent = getAccent cfg cfg.colorscheme.name;
    in
    {
      enable = cfg.enable;
      inherit accent variant;
      flavor = variant;
      style = variant;
    };

  mkColorschemeAssertions =
    cfg:
    let
      colorschemeName = cfg.colorscheme.name;
      meta = colorschemeMeta.${colorschemeName};
      variant = getVariant cfg colorschemeName;
      accent = getAccent cfg colorschemeName;
      hasAccent = meta ? accents;
    in
    [
      {
        assertion = !cfg.enable || meta.variants == [ ] || builtins.elem variant meta.variants;
        message = "nixporn: `${toString variant}` is not a valid variant for `${colorschemeName}`.";
      }
      {
        assertion = !cfg.enable || cfg.colorscheme.accent == null || hasAccent;
        message = "nixporn: `${colorschemeName}` does not support `nixporn.colorscheme.accent`.";
      }
      {
        assertion = !cfg.enable || !hasAccent || builtins.elem accent meta.accents;
        message = "nixporn: `${toString accent}` is not a valid accent for `${colorschemeName}`.";
      }
    ];

  mkLegacyColorschemeConfig =
    cfg:
    let
      selected = mkSelectedColorschemeConfig cfg;
    in
    mkIf cfg.enable (
      mkMerge (
        builtins.map (
          colorschemeName:
          let
            meta = colorschemeMeta.${colorschemeName};
          in
          mkIf (cfg.colorscheme.name == colorschemeName) (mkMerge [
            {
              nixporn.${colorschemeName}.enable = mkDefault true;
            }
            (mkIf (meta.variantOption != null) {
              nixporn.${colorschemeName}.${meta.variantOption} = mkDefault selected.variant;
            })
            (mkIf (colorschemeName == "catppuccin") {
              nixporn.catppuccin.accent = mkDefault selected.accent;
            })
          ])
        ) supportedColorschemes
      )
    );

  resolveColorscheme =
    {
      cfg,
      ...
    }:
    let
      selected = cfg.colorscheme.name;
    in
    if !cfg.enable then null else presets.${selected}.colorscheme (mkSelectedColorschemeConfig cfg);

  inherit (options) mkNixpornOptions;
in
{
  lib = helpers;

  inherit
    colorschemeMeta
    colorschemes
    getAccent
    getVariant
    mkColorschemeAssertions
    mkLegacyColorschemeConfig
    mkNixpornOptions
    mkSelectedColorschemeConfig
    options
    palettes
    presets
    resolveColorscheme
    supportedColorschemes
    targetNames
    ;
}
