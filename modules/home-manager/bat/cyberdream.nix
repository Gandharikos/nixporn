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
  targetCfg = config.nixporn.targets."bat";
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.bat = {
      config.theme = slug;
      themes.${slug} = {
        inherit src;
        file = "extras/textmate/${slug}.tmTheme";
      };
    };
  };
}
