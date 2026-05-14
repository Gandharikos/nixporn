{
  lib,
  name,
  ...
}:
let
  sources = builtins.fromJSON (builtins.readFile ../../pkgs/dracula/sources.json);
in
{
  targets = lib.mapAttrs (_: metadata: metadata) sources;

  variantFor = _: "default";

  slugFor = _: _: name;

  ansiFor = _: palette: {
    bg = palette.bg;
    fg = palette.fg;

    inherit (palette)
      black
      bright_blue
      bright_cyan
      bright_green
      bright_magenta
      bright_red
      bright_white
      bright_yellow
      cyan
      green
      red
      white
      yellow
      ;

    blue = palette.purple;
    bright_black = palette.comment;
    magenta = palette.pink;
  };
}
