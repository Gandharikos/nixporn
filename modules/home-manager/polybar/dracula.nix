{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "polybar";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    services.polybar.extraConfig = lib.fileContents "${sources.polybar}/config.ini";
  };
}
