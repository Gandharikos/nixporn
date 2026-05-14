{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "fuzzel";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fuzzel.settings.main.include = "${sources.fuzzel}/fuzzel.ini";
  };
}
