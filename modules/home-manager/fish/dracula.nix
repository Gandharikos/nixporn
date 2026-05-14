{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "fish";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
  themeName = "Dracula Official";
in
{
  config = lib.mkIf enable {
    xdg.configFile."fish/themes/${themeName}.theme".source =
      "${sources.fish}/themes/${themeName}.theme";
    programs.fish.shellInit = ''
      fish_config theme choose "${themeName}"
    '';
  };
}
