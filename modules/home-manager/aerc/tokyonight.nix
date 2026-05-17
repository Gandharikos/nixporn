{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) palette slug;
  source = pkgs.nixporn.tokyonight;
  target = "aerc";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
  styleset = lib.fileContents "${source}/extras/aerc/${slug}.ini";
  transparentStyleset =
    lib.replaceStrings
      [
        palette.bg
        palette.bg_dark
      ]
      [
        "default"
        "default"
      ]
      styleset;
in
{
  config = lib.mkIf enable {
    programs.aerc = {
      stylesets.${slug} = if cfg.transparent then transparentStyleset else styleset;
      extraConfig.ui.styleset-name = slug;
    };
  };
}
