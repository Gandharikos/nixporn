{
  config,
  lib,
  nixpornSources,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."spicetify";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.spicetify = {
      theme = {
        name = "Tokyo";
        src = nixpornSources.tokyonight-spotify;
        overwriteAssets = true;
      };
      colorScheme =
        if cfg.variant == "night" then
          "Night"
        else if cfg.variant == "storm" then
          "Storm"
        else if cfg.variant == "day" then
          "Light"
        else
          "Night";
    };
  };
}
