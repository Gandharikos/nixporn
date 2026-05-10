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
  targetCfg = config.nixporn.targets."tmux";
  file = "solarized_osaka_${cfg.variant}";
  enable = cfg.enable && targetCfg.enable && (config.programs.tmux.enable or false);
in
{
  config = mkIf enable {
    programs.tmux.extraConfig = builtins.readFile "${src}/extras/tmux/${file}.tmux";
  };
}
