{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "zellij";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."zellij/themes/dracula.kdl".source = "${sources.zellij}/dracula.kdl";
    programs.zellij.settings.theme = "dracula";
  };
}
