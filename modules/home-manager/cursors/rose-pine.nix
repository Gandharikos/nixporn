{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "cursors";
  colorscheme = cfg.colorschemes.rose-pine;
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  cursorVariant =
    if cfg.${target}.accent == "auto" then
      colorscheme.variant
    else if cfg.${target}.accent == "light" then
      "dawn"
    else
      "main";
  defaultBaseColor =
    if cfg.${target}.accent == "light" then
      "#faf4ed"
    else if cfg.${target}.accent == "dark" then
      "#191724"
    else
      colorscheme.palette.base;
  defaultOutlineColor =
    if cfg.${target}.accent == "light" then
      "#464261"
    else if cfg.${target}.accent == "dark" then
      "#e0def4"
    else
      colorscheme.palette.text;
  cursorPackage = pkgs.nixporn.rose-pine.cursors.override {
    variant = cursorVariant;
    inherit (cfg.${target}.rose-pine) baseColor outlineColor;
  };
in
{
  options.nixporn.cursors.rose-pine = {
    baseColor = lib.mkOption {
      type = lib.types.str;
      default = defaultBaseColor;
      description = "Base color for generated Rosé Pine cursors.";
    };

    outlineColor = lib.mkOption {
      type = lib.types.str;
      default = defaultOutlineColor;
      description = "Outline color for generated Rosé Pine cursors.";
    };
  };

  config = lib.mkIf enable {
    home.pointerCursor = {
      name = cursorPackage.cursorThemeName;
      package = cursorPackage;
    };

    home.sessionVariables.HYPRCURSOR_THEME = cursorPackage.cursorThemeName;
  };
}
