{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "mako";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    services.mako.settings.include = "${sources.mako}/config";
  };
}
