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
      slug = "decay-${cfg.variant}";
      displayName = "Decay ${lib.toSentenceCase cfg.variant}";
      author = "decaycs";
      description = "A soft dark colorscheme from decay.nvim.";
      palette = palettes.decay.${cfg.variant};
    };
}
