{
  config,
  lib,
  nixpornSources,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."bat";
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.bat = {
      config.theme = slug;
      themes."${slug}" = {
        inherit src;
        file = "extras/sublime/${slug}.tmTheme";
      };
    };
  };
}
