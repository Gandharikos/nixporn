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
      displayName = "Nordic";
      author = "Arctic Ice Studio";
      description = "An arctic, north-bluish color palette.";
      palette = palettes.nordic;
    };
}
