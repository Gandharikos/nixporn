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
  targetCfg = config.nixporn.targets."delta";
  inherit (config.nixporn.colorscheme) slug;
  file = "solarized_osaka_${cfg.variant}";
  enable = cfg.enable && targetCfg.enable && (config.programs.delta.enable or false);
in
{
  config = mkIf enable {
    programs.git.includes = [ { path = "${src}/extras/delta/${file}.gitconfig"; } ];
    programs.delta.options.features = slug;
  };
}
