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
  targetCfg = config.nixporn.targets."opencode";
  inherit (config.nixporn.colorscheme) slug;
  enable = cfg.enable && targetCfg.enable && (config.programs.opencode.enable or false);
in
{
  config = mkIf enable {
    programs.opencode.tui.theme = slug;
    xdg.configFile."opencode/themes/${slug}.json".source = "${src}/extras/opencode/${slug}.json";
  };
}
