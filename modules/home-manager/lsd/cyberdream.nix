{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) cyberdream;
  inherit (cyberdream) slug;
  source = pkgs.nixporn.cyberdream;
  target = "lsd";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."lsd/colors.yaml".source = "${source}/extras/lsd/${slug}.yml";
    programs.lsd.settings.color.theme = "custom";
  };
}
