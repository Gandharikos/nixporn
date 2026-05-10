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
  targetCfg = config.nixporn.targets."kitty";
  file = "solarized_osaka_${cfg.variant}";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.kitty.extraConfig = ''
      include ${src}/extras/kitty/${file}.conf
    '';
  };
}
