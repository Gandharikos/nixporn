{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg)
    avatar
    palette
    wallpaper
    ;
  inherit (cfg.colorschemes) catppuccin;
  target = "noctalia-shell";
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && (config.programs.noctalia-shell.enable or false);
  accent = palette.${catppuccin.accent};
in
{
  config = lib.mkIf enable {
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
        darkMode = catppuccin.flavor != "latte";
        predefinedScheme = "";
        useWallpaperColors = false;
      };

      settings.general = lib.optionalAttrs (avatar != null) {
        avatarImage = toString avatar;
      };

      settings.wallpaper = lib.optionalAttrs (wallpaper != null) {
        enabled = true;
        directory = builtins.dirOf (toString wallpaper);
      };
    };
  };
}
