{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = "decay-${cfg.variant}";
    palette = palettes.decay.${cfg.variant};
  };
}
