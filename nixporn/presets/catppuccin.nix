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
      slug = "catppuccin-${cfg.flavor}-${cfg.accent}";
      displayName = "Catppuccin ${lib.toSentenceCase cfg.flavor}";
      author = "Catppuccin";
      description = "A soothing pastel color scheme by Catppuccin.";
      palette = palettes.catppuccin.${cfg.flavor};
    };
}
