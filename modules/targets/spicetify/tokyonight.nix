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
        if cfg.style == "night" then
          "Night"
        else if cfg.style == "storm" then
          "Storm"
        else if cfg.style == "day" then
          "Light"
        else
          "Night";
    };
  };
}
