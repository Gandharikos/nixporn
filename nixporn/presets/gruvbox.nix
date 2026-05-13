{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = "gruvbox-${cfg.variant}";
    palette = palettes.gruvbox.${cfg.variant};
  };
}
