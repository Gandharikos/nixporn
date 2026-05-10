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
      palette = palettes.cyberdream.${cfg.variant};
    };
}
