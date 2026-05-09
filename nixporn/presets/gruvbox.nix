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
    cfg:
    mkColorscheme {
      slug = "gruvbox-${cfg.variant}";
      displayName = "Gruvbox ${lib.toSentenceCase cfg.variant}";
      author = "Pavel Pertsev";
      description = "A retro groove color scheme.";
      palette = palettes.gruvbox.${cfg.variant};
    };
}
