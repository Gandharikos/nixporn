{
  lib,
  name,
  ...
}:
let
  sources = builtins.fromJSON (builtins.readFile ../../pkgs/dracula/sources.json);
in
{
  targets = lib.mapAttrs (_: metadata: metadata) sources // {
    spicetify = {
      url = "github:dracula/spicetify";
      rev = "63b2e835d8079d840277defa53651f65deee7d0c";
      hash = "sha256-/5ikaxHIAxODEOJkPKFbA80fxYtPQzN0gXGg7S4RYQA=";
    };
  };

  variantFor = _: "default";

  slugFor = _: _: name;

  ansiFor = _: palette: {
    inherit (palette)
      bg
      fg
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
