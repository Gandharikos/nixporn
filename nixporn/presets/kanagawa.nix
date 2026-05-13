{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = "kanagawa-${cfg.variant}";
    palette = palettes.kanagawa.${cfg.variant};
  };
}
