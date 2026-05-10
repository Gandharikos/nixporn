{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.cyberdream;
  cfg = config.nixporn.cyberdream;
  targetCfg = config.nixporn.targets."tmux";
  inherit (config.nixporn.colorscheme) slug;
  enable = cfg.enable && targetCfg.enable && (config.programs.tmux.enable or false);
in
{
  config = mkIf enable {
    programs.tmux.extraConfig = builtins.readFile "${src}/extras/tmux/${slug}.conf";
  };
}
