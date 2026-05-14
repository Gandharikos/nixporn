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
  target = "micro";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  transparent = cfg.${target}.transparent;
  themePath = "catppuccin-${flavor}" + lib.optionalString transparent "-transparent" + ".micro";
in
{
  config = lib.mkIf enable {
    programs.micro.settings.colorscheme = lib.removeSuffix ".micro" themePath;
    xdg.configFile."micro/colorschemes/${themePath}".source = "${sources.micro}/themes/${themePath}";
  };
}
