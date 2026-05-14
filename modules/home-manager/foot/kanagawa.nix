{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) kanagawa;
  inherit (kanagawa) slug;
  source = pkgs.nixporn.kanagawa;
  target = "foot";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.foot.settings.main.include = "${source}/extras/foot/${slug}.ini";
  };
}
