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
  targetCfg = config.nixporn.targets."yazi";
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable && config.programs.yazi.enable) {
    xdg.configFile."yazi/theme.toml".source = "${src}/extras/yazi/${slug}.toml";
  };
}
