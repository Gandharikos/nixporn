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
      palette = palettes."rose-pine".${cfg.variant};
    };
}
