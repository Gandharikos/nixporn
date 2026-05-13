{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = "catppuccin-${cfg.flavor}-${cfg.accent}";
    palette = palettes.catppuccin.${cfg.flavor};
  };
}
