{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."television";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.television.settings.theme = "tokyonight";
  };
}
