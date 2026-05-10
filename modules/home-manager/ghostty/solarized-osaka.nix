{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources."solarized-osaka";
  cfg = config.nixporn."solarized-osaka";
  targetCfg = config.nixporn.targets."ghostty";
  file = "solarized_osaka_${cfg.variant}";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.ghostty.settings.theme = "${src}/extras/ghostty/${file}";
  };
}
