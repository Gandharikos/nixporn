{
  lib,
  nixpornSources,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."delta";
  enable = cfg.enable && targetCfg.enable && (config.programs.delta.enable or false);
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf enable {
    programs = {
      git.includes = [ { path = "${src}/extras/delta/${slug}.gitconfig"; } ];
      delta.options.features = slug;
    };
  };
}
