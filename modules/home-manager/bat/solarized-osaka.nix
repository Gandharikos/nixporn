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
  targetCfg = config.nixporn.targets."bat";
  inherit (config.nixporn.colorscheme) slug;
  file = "solarized_osaka_${cfg.variant}";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.bat = {
      config.theme = slug;
      themes.${slug} = {
        inherit src;
        file = "extras/sublime/${file}.tmTheme";
      };
    };
  };
}
