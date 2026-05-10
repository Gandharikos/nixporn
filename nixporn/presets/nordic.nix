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
      slug = "nordic";
      palette = palettes.nordic;
    };
}
