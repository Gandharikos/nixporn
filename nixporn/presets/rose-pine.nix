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
      slug = if cfg.variant == "main" then "rose-pine" else "rose-pine-${cfg.variant}";
      displayName = "Rose Pine ${lib.toSentenceCase cfg.variant}";
      author = "Rose Pine";
      description = "All natural pine, faux fur and a bit of soho vibes.";
      palette = palettes."rose-pine".${cfg.variant};
    };
}
