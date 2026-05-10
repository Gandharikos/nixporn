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
  targetCfg = config.nixporn.targets."ghostty";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.ghostty.settings.theme = "${src}/extras/ghostty/kanagawa-${cfg.variant}";
  };
}
