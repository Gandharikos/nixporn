{
  lib,
  nixpornSources,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."zathura";
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable && config.programs.zathura.enable) {
    programs.zathura.extraConfig = "include ${src + "/extras/zathura/" + slug + ".zathurarc"}";
  };
}
