{
  config,
  lib,
  nixpornSources,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf importTOML;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."dunst";
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    services.dunst.settings = importTOML "${src}/extras/dunst/${slug}.dunstrc";
  };
}
