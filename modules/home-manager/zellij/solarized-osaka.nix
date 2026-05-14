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
  target = "zellij";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."zellij/themes/${slug}.kdl".source = "${source}/extras/zellij/${slug}.kdl";
    programs.zellij.settings.theme = slug;
  };
}
