{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = if cfg.variant == "default" then "cyberdream" else "cyberdream-${cfg.variant}";
    palette = palettes.cyberdream.${cfg.variant};
  };
}
