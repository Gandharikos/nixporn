{
  lib,
  name,
  ...
}:
let
  sources = builtins.fromJSON (builtins.readFile ../../pkgs/dracula/sources.json);
  extraSources = builtins.fromJSON (builtins.readFile ../../pkgs/extra-sources.json);
in
{
  targets = lib.mapAttrs (_: metadata: metadata) sources // {
    spicetify = {
      inherit (extraSources.dracula-spicetify) narHash rev url;
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
