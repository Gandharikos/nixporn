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
      palette = palettes.decay.${cfg.variant};
    };
}
