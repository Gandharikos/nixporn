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
      slug = "tokyonight_${cfg.variant}";
      palette = palettes.tokyonight.${cfg.variant};
    };
}
