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
      palette = palettes.kanagawa.${cfg.variant};
    };
}
