{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixporn.colorscheme)
    slug
    palette
    ;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."dank-material-shell";
  dmsEnabled = config.programs.dank-material-shell.enable or false;
  theme = {
    primary = palette.base.blue;
    primaryText = palette.base.bg;
    primaryContainer = palette.base.cyan;
    secondary = palette.base.magenta;
    surface = palette.base.bg;
    surfaceText = palette.base.fg;
    surfaceVariant = palette.base.bg_highlight;
    surfaceVariantText = palette.base.fg_dark;
    surfaceTint = palette.base.blue;
    background = palette.base.bg_dark;
    backgroundText = palette.base.fg;
    outline = palette.base.fg_gutter;
    surfaceContainer = palette.base.bg;
    surfaceContainerHigh = palette.base.bg_highlight;
    surfaceContainerHighest = palette.base.bright_black;
    error = palette.base.red;
    warning = palette.base.orange;
    info = palette.base.cyan;
  };
in
{
  config = mkIf (cfg.enable && targetCfg.enable && dmsEnabled) {
    programs.dank-material-shell.settings = {
      currentThemeName = "custom";
      customThemeFile = pkgs.writeText "dank-material-shell-${slug}-theme.json" (
        builtins.toJSON {
          dark = theme;
          light = theme;
        }
      );
    };
  };
}
