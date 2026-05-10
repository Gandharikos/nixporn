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
  targetCfg = config.nixporn.targets."xresources";
  file = "solarized_osaka_${cfg.variant}";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    xresources.extraConfig = builtins.readFile "${src}/extras/xresources/${file}.Xresources";
  };
}
