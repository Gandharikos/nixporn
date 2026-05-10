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
  targetCfg = config.nixporn.targets."xresources";
  file =
    if cfg.variant == "wave" then
      "kanagawa.Xresources"
    else if cfg.variant == "dragon" then
      "kanagawa_dragon.Xresources"
    else
      "kanagawa_lotus.Xresources";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    xresources.extraConfig = builtins.readFile "${src}/extras/xresources/${file}";
  };
}
