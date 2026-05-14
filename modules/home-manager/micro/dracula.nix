{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "micro";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.micro.settings.colorscheme = "dracula";
    xdg.configFile."micro/colorschemes/dracula.micro".source = "${sources.micro}/dracula.micro";
  };
}
