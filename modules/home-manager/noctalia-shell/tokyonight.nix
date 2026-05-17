{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg) palette;
  inherit (cfg.colorschemes) tokyonight;
  target = "noctalia-shell";
  enable =
    cfg.enable
    && cfg.colorscheme == "tokyonight"
    && cfg.${target}.enable
    && (config.programs.noctalia-shell.enable or false);
in
{
  config = lib.mkIf enable {
    programs.noctalia-shell = {
      colors = {
        mPrimary = palette.blue;
        mOnPrimary = palette.bg;
        mSecondary = palette.magenta;
        mOnSecondary = palette.bg;
        mTertiary = palette.green;
        mOnTertiary = palette.bg;
        mError = palette.red;
        mOnError = palette.bg;
        mSurface = palette.bg;
        mOnSurface = palette.fg;
        mHover = palette.cyan;
        mOnHover = palette.bg;
        mSurfaceVariant = palette.bg_highlight;
        mOnSurfaceVariant = palette.fg_dark;
        mOutline = palette.fg_gutter;
        mShadow = palette.black;
      };

      settings.colorSchemes = {
        darkMode = tokyonight.style != "day";
        predefinedScheme = "";
        useWallpaperColors = false;
      };
    };
  };
}
