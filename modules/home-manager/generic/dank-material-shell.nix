{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg) avatar wallpaper;
  target = "dank-material-shell";
  colorscheme = cfg.colorscheme;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable =
    cfg.enable
    && cfg.${target}.enable
    && !hasSpecific
    && (config.programs.dank-material-shell.enable or false);
  inherit (cfg.palette) ansi;

  themeName = "nixporn-${colorschemeCfg.slug}";
  theme = {
    primary = ansi.blue;
    primaryText = ansi.bg;
    primaryContainer = ansi.cyan;
    secondary = ansi.magenta;
    surface = ansi.black;
    surfaceText = ansi.fg;
    surfaceVariant = ansi.black;
    surfaceVariantText = ansi.white;
    surfaceTint = ansi.blue;
    background = ansi.bg;
    backgroundText = ansi.fg;
    outline = ansi.bright_black;
    surfaceContainer = ansi.black;
    surfaceContainerHigh = ansi.bright_black;
    surfaceContainerHighest = ansi.bright_black;
    error = ansi.red;
    warning = ansi.yellow;
    info = ansi.blue;
  };
in
{
  config = lib.mkIf enable {
    programs.dank-material-shell.settings = {
      currentThemeName = "custom";
      customThemeFile = pkgs.writeText "dank-material-shell-${themeName}-theme.json" (
        builtins.toJSON {
          dark = theme;
          light = theme;
        }
      );
    };

    programs.dank-material-shell.session = lib.optionalAttrs (wallpaper != null) {
      wallpaperPath = toString wallpaper;
      wallpaperPathLight = toString wallpaper;
      wallpaperPathDark = toString wallpaper;
    };

    home.file = lib.optionalAttrs (avatar != null) {
      ".face".source = avatar;
    };
  };
}
