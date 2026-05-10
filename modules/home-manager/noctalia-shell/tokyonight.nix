{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixporn.colorscheme) palette;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."noctalia-shell";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.noctalia-shell = {
      colors = {
        mPrimary = palette.base.blue;
        mOnPrimary = palette.base.bg;
        mSecondary = palette.base.magenta;
        mOnSecondary = palette.base.bg;
        mTertiary = palette.base.green;
        mOnTertiary = palette.base.bg;
        mError = palette.base.red;
        mOnError = palette.base.bg;
        mSurface = palette.base.bg;
        mOnSurface = palette.base.fg;
        mHover = palette.base.cyan;
        mOnHover = palette.base.bg;
        mSurfaceVariant = palette.base.bg_highlight;
        mOnSurfaceVariant = palette.base.fg_dark;
        mOutline = palette.base.fg_gutter;
        mShadow = palette.base.black;
      };

      settings.colorSchemes = {
        darkMode = cfg.variant != "day";
        predefinedScheme = "";
        useWallpaperColors = false;
      };
    };
  };
}
