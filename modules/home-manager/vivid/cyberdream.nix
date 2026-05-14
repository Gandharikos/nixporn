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
  target = "vivid";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."vivid/themes/${slug}.yml".source = "${source}/extras/vivid/${slug}.yml";
    programs.vivid.activeTheme = slug;
  };
}
