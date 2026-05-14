{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "aerc";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.aerc = {
      stylesets.${slug} = lib.fileContents "${source}/extras/aerc/${slug}.ini";
      extraConfig.ui.styleset-name = slug;
    };
  };
}
