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
      slug = "gruvbox-${cfg.variant}";
      palette = palettes.gruvbox.${cfg.variant};
    };
}
