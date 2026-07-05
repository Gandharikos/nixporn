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
  target = "noctalia";
  hasProgram = options.programs ? noctalia;
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && (config.programs.noctalia.enable or false);
  accent = palette.${catppuccin.accent};
  noctaliaPalette = {
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
    terminal = {
      normal = {
        black = palette.surface1;
        inherit (palette)
          red
          green
          yellow
          blue
          ;
        magenta = palette.pink;
        cyan = palette.teal;
        white = palette.subtext0;
      };
      bright = {
        black = palette.surface2;
        red = palette.red;
        green = palette.green;
        yellow = palette.yellow;
        blue = palette.sapphire;
        magenta = palette.pink;
        cyan = palette.teal;
        white = palette.subtext1;
      };
      foreground = palette.text;
      background = palette.base;
      cursor = palette.rosewater;
      cursorText = palette.crust;
      selectionFg = palette.text;
      selectionBg = palette.surface0;
    };
  };
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.noctalia = {
        customPalettes.nixporn = lib.mkForce {
          dark = noctaliaPalette;
          light = noctaliaPalette;
        };

        settings.theme = {
          mode = lib.mkForce catppuccin.polarity;
          source = lib.mkForce "custom";
          custom_palette = lib.mkForce "nixporn";
        };
      };
    }
  );
}
