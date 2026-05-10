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
  targetCfg = config.nixporn.targets."discord";
  inherit (config.nixporn.general) transparent;
  inherit (config.nixporn.colorscheme) slug;
  file = "solarized_osaka_${cfg.variant}";
  enable = cfg.enable && targetCfg.enable && (config.programs.nixcord.enable or false);
in
{
  config = mkIf enable {
    programs.nixcord.config = {
      inherit transparent;
      frameless = true;
      enabledThemes = [ "${slug}.css" ];
    };
    home.file."${config.programs.nixcord.configDir}/themes/${slug}.css".source =
      "${src}/extras/discord/${file}.css";
  };
}
