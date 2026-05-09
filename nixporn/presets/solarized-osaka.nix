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
      slug = "solarized-osaka-${cfg.variant}";
      displayName = "Solarized Osaka ${lib.toSentenceCase cfg.variant}";
      author = "craftzdog";
      description = "A clean Solarized-derived colorscheme from solarized-osaka.nvim.";
      palette = palettes."solarized-osaka".${cfg.variant};
    };
}
