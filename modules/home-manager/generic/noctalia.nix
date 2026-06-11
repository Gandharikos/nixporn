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
    terminal = {
      normal = {
        inherit (ansi)
          black
          red
          green
          yellow
          blue
          magenta
          cyan
          white
          ;
      };
      bright = {
        black = ansi.bright_black;
        red = ansi.bright_red;
        green = ansi.bright_green;
        yellow = ansi.bright_yellow;
        blue = ansi.bright_blue;
        magenta = ansi.bright_magenta;
        cyan = ansi.bright_cyan;
        white = ansi.bright_white;
      };
      foreground = ansi.fg;
      background = ansi.bg;
      cursor = ansi.fg;
      cursorText = ansi.bg;
      selectionFg = ansi.fg;
      selectionBg = ansi.bright_black;
    };
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
