{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg)
    avatar
    palette
    wallpaper
    ;
  inherit (cfg.colorschemes.catppuccin) accent slug;
  target = "dank-material-shell";
  hasProgram = options.programs ? dank-material-shell;
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && (config.programs.dank-material-shell.enable or false);
  theme = {
    primary = palette.${accent};
    primaryText = palette.base;
    primaryContainer = palette.teal;
    secondary = palette.peach;
    surface = palette.mantle;
    surfaceText = palette.text;
    surfaceVariant = palette.surface0;
    surfaceVariantText = palette.subtext1;
    surfaceTint = palette.${accent};
    background = palette.base;
    backgroundText = palette.text;
    outline = palette.surface2;
    surfaceContainer = palette.mantle;
    surfaceContainerHigh = palette.surface0;
    surfaceContainerHighest = palette.surface2;
    error = palette.red;
    warning = palette.peach;
    info = palette.blue;
  };
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.dank-material-shell.settings = {
        currentThemeName = "custom";
        customThemeFile = pkgs.writeText "dank-material-shell-${slug}-theme.json" (
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
    }
  );
}
