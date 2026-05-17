{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg)
    palette
    ;
  inherit (cfg.colorschemes.tokyonight) slug;
  target = "dank-material-shell";
  enable =
    cfg.enable
    && cfg.colorscheme == "tokyonight"
    && cfg.${target}.enable
    && (config.programs.dank-material-shell.enable or false);
  theme = {
    primary = palette.blue;
    primaryText = palette.bg;
    primaryContainer = palette.cyan;
    secondary = palette.magenta;
    surface = palette.bg;
    surfaceText = palette.fg;
    surfaceVariant = palette.bg_highlight;
    surfaceVariantText = palette.fg_dark;
    surfaceTint = palette.blue;
    background = palette.bg_dark;
    backgroundText = palette.fg;
    outline = palette.fg_gutter;
    surfaceContainer = palette.bg;
    surfaceContainerHigh = palette.bg_highlight;
    surfaceContainerHighest = palette.bright_black;
    error = palette.red;
    warning = palette.orange;
    info = palette.cyan;
  };
in
{
  config = lib.mkIf enable {
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
