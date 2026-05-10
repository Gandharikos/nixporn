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
      slug = "catppuccin-${cfg.flavor}-${cfg.accent}";
      palette = palettes.catppuccin.${cfg.flavor};
    };
}
