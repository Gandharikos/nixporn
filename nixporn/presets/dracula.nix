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
      displayName = "Dracula";
      author = "Dracula";
      description = "A dark colorscheme for many editors, shells, and applications.";
      palette = palettes.dracula;
    };
}
