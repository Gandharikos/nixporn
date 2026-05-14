{
  lib,
  name,
  variantNames,
  ...
}:
let
  sources = builtins.fromJSON (builtins.readFile ../../pkgs/rose-pine/sources.json);
in
{
  lightVariants = [ "dawn" ];

  targets = lib.mapAttrs (_: metadata: metadata) sources;

  options.variant = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "main";
    description = "The ${name} variant.";
  };

  variantFor = colorscheme: colorscheme.variant;

  slugFor = _: variant: if variant == "main" then name else "${name}-${variant}";

  ansiFor = _: palette: {
    bg = palette.base;
    fg = palette.text;
    black = palette.base;
    red = palette.love;
    green = palette.pine;
    yellow = palette.gold;
    blue = palette.foam;
    magenta = palette.iris;
    cyan = palette.rose;
    white = palette.text;
    bright_black = palette.muted;
    bright_red = palette.love;
    bright_green = palette.pine;
    bright_yellow = palette.gold;
    bright_blue = palette.foam;
    bright_magenta = palette.iris;
    bright_cyan = palette.rose;
    bright_white = palette.text;
  };
}
