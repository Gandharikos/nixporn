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
      palette = palettes."solarized-osaka".${cfg.variant};
    };
}
