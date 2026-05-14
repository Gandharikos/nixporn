{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "fish";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}";
in
{
  config = lib.mkIf enable {
    xdg.configFile."fish/themes/${themeName}.theme".source =
      "${sources.fish}/static/${themeName}.theme";
    programs.fish.shellInit = ''
      fish_config theme choose "${themeName}"
    '';
  };
}
