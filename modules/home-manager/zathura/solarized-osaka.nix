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
  targetCfg = config.nixporn.targets."zathura";
  file = "solarized_osaka_${cfg.variant}";
in
{
  config = mkIf (cfg.enable && targetCfg.enable && config.programs.zathura.enable) {
    programs.zathura.extraConfig = "include ${src}/extras/zathura/${file}.zathurarc";
  };
}
