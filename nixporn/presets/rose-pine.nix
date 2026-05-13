{
  lib,
  helpers,
  palettes,
}:
{
  colorscheme = cfg: {
    slug = if cfg.variant == "main" then "rose-pine" else "rose-pine-${cfg.variant}";
    palette = palettes."rose-pine".${cfg.variant};
  };
}
