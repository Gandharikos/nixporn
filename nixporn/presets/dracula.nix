{
  lib,
  helpers,
  palettes,
}:
let
  inherit (helpers) mkColorscheme;
in
{
  colorscheme =
    _:
    mkColorscheme {
      slug = "dracula";
      palette = palettes.dracula;
    };
}
