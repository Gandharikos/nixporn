{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = "tokyonight_${cfg.variant}";
    palette = palettes.tokyonight.${cfg.variant};
  };
}
