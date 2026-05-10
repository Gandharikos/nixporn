{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.kanagawa;
  cfg = config.nixporn.kanagawa;
  targetCfg = config.nixporn.targets."kitty";
  file =
    if cfg.variant == "wave" then
      "kanagawa.conf"
    else if cfg.variant == "dragon" then
      "kanagawa_dragon.conf"
    else
      "kanagawa_light.conf";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.kitty.extraConfig = ''
      include ${src}/extras/kitty/${file}
    '';
  };
}
