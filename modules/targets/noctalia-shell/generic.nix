{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}@moduleArgs:
let
  common = import ../common.nix { inherit colorschemeName; } moduleArgs;
  inherit (common)
    cfg
    colors
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
in
{
  config = mkIf (targetEnabled "noctalia-shell") {
    programs.noctalia-shell = mkIf (config.programs.noctalia-shell.enable or false) {
      colors = with colors; {
        mPrimary = blue;
        mOnPrimary = bg;
        mSecondary = magenta;
        mOnSecondary = bg;
        mTertiary = green;
        mOnTertiary = bg;
        mError = red;
        mOnError = bg;
        mSurface = bg;
        mOnSurface = fg;
        mHover = cyan;
        mOnHover = bg;
        mSurfaceVariant = bg_highlight;
        mOnSurfaceVariant = fg_dark;
        mOutline = fg_gutter;
        mShadow = black;
      };
      settings.colorSchemes = {
        darkMode = !isLight;
        predefinedScheme = "";
        useWallpaperColors = false;
      };
    };
  };
}
