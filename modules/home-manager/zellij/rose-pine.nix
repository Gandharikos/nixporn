{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "zellij";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."zellij/themes/${slug}.kdl".source = "${sources.zellij}/dist/${slug}.kdl";
    programs.zellij.settings.theme = slug;
  };
}
