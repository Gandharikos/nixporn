{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  source = pkgs.nixporn.solarized-osaka;
  target = "aerc";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.aerc = {
      stylesets.${slug} = lib.fileContents "${source}/extras/aerc/${slug}.ini";
      extraConfig.ui.styleset-name = slug;
    };
  };
}
