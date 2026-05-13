{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = "solarized-osaka-${cfg.variant}";
    palette = palettes."solarized-osaka".${cfg.variant};
  };
}
