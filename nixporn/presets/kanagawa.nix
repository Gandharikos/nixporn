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
      slug = "kanagawa-${cfg.variant}";
      displayName = "Kanagawa ${lib.toSentenceCase cfg.variant}";
      author = "Tommaso Laurenzi";
      description = "A colorscheme inspired by The Great Wave off Kanagawa.";
      palette = palettes.kanagawa.${cfg.variant};
    };
}
