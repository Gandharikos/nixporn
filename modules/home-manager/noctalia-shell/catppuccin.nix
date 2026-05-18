{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg) palette;
  inherit (cfg.colorschemes) catppuccin;
  target = "noctalia-shell";
  hasProgram = options.programs ? noctalia-shell;
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && (config.programs.noctalia-shell.enable or false);
  accent = palette.${catppuccin.accent};
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
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
      };
    }
  );
}
