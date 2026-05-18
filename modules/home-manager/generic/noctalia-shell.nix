{ targetPath }:
{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.nixporn;
  target = "noctalia-shell";
  hasProgram = options.programs ? noctalia-shell;
  inherit (cfg) colorscheme;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable =
    cfg.enable
    && cfg.${target}.enable
    && !hasSpecific
    && (config.programs.noctalia-shell.enable or false);
  inherit (cfg.palette) ansi;
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.noctalia-shell = {
        colors = {
          mPrimary = ansi.blue;
          mOnPrimary = ansi.bg;
          mSecondary = ansi.magenta;
          mOnSecondary = ansi.bg;
          mTertiary = ansi.cyan;
          mOnTertiary = ansi.bg;
          mError = ansi.red;
          mOnError = ansi.bg;
          mSurface = ansi.bg;
          mOnSurface = ansi.fg;
          mHover = ansi.cyan;
          mOnHover = ansi.bg;
          mSurfaceVariant = ansi.black;
          mOnSurfaceVariant = ansi.white;
          mOutline = ansi.bright_black;
          mShadow = ansi.black;
        };

        settings.colorSchemes = {
          darkMode = colorschemeCfg.polarity == "dark";
          predefinedScheme = "";
          useWallpaperColors = false;
        };
      };
    }
  );
}
