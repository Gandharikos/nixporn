{ targetPath }:
{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.nixporn;
  target = "noctalia";
  hasProgram = options.programs ? noctalia;
  inherit (cfg) colorscheme;
  inherit (cfg.palette) ansi;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable =
    cfg.enable && cfg.${target}.enable && !hasSpecific && (config.programs.noctalia.enable or false);
  palette = {
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
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.noctalia = {
        customPalettes.nixporn = lib.mkDefault {
          dark = palette;
          light = palette;
        };

        settings.theme = {
          mode = lib.mkDefault colorschemeCfg.polarity;
          source = lib.mkDefault "custom";
          custom_palette = lib.mkDefault "nixporn";
        };
      };
    }
  );
}
