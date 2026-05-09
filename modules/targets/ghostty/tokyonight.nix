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
  targetCfg = config.nixporn.targets."ghostty";
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.ghostty.settings.theme = "${src + "/extras/ghostty/" + slug}";
  };
}
