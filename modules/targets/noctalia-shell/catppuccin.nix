{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixporn.colorscheme) palette;
  cfg = config.nixporn.catppuccin;
  targetCfg = config.nixporn.targets."noctalia-shell";
  accent = palette.${cfg.accent};
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.noctalia-shell = {
      colors = {
        mPrimary = accent;
        mOnPrimary = palette.base;
        mSecondary = palette.peach;
        mOnSecondary = palette.base;
        mTertiary = palette.teal;
        mOnTertiary = palette.base;
        mError = palette.red;
        mOnError = palette.base;
        mSurface = palette.base;
        mOnSurface = palette.text;
        mHover = palette.teal;
        mOnHover = palette.base;
        mSurfaceVariant = palette.surface0;
        mOnSurfaceVariant = palette.subtext1;
        mOutline = palette.surface2;
        mShadow = palette.crust;
      };

      settings.colorSchemes = {
        darkMode = cfg.flavor != "latte";
        predefinedScheme = "";
        useWallpaperColors = false;
      };
    };
  };
}
