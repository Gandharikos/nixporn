{
  lib,
  config,
  nixpornSources,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) removeAttrs;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."gemini-cli";
  enable = cfg.enable && targetCfg.enable && (config.programs.gemini-cli.enable or false);
  inherit (config.nixporn.colorscheme) slug;

  # Use builtins.fromJSON to avoid home-manager metadata
  rawTheme = builtins.fromJSON (builtins.readFile "${src}/extras/gemini_cli/${slug}.json");

  # Remove unsupported fields from text section
  cleanedTheme = rawTheme // {
    text = removeAttrs (rawTheme.text or { }) [ "response" ];
  };
in
{
  config = mkIf enable {
    programs."gemini-cli".settings.ui = {
      theme = slug;
      customThemes."${slug}" = cleanedTheme // {
        type = "custom";
        name = slug;
      };
    };
  };
}
