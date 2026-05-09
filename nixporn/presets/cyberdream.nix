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
      slug = if cfg.variant == "default" then "cyberdream" else "cyberdream-${cfg.variant}";
      displayName =
        if cfg.variant == "default" then "Cyberdream" else "Cyberdream ${lib.toSentenceCase cfg.variant}";
      author = "scottmckendry";
      description = "A high-contrast, futuristic and vibrant colorscheme.";
      palette = palettes.cyberdream.${cfg.variant};
    };
}
