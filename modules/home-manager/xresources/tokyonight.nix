{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  target = "xresources";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xresources.properties."*cursorColor" = tokyonight.palette.bg_search;
  };
}
