{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (config.nixporn.colorscheme) palette;

  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."niri";
  enable = cfg.enable && targetCfg.enable && isLinux;
in
{
  config = mkIf enable {
    programs.niri.settings.layout = {
      background-color = palette.base.bg;
      border = {
        active.color = palette.base.magenta;
        inactive.color = palette.base.bg_highlight;
        urgent.color = palette.base.red;
      };
      focus-ring = {
        active.gradient = {
          from = palette.base.blue;
          to = palette.base.magenta;
          angle = 45;
          in' = "oklch longer hue";
        };
        inactive.color = palette.base.bg_dark;
        urgent.color = palette.base.yellow;
      };
    };
  };
}
