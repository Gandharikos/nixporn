{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg) palette;
  target = "niri";
  enable =
    cfg.enable
    && cfg.colorscheme == "tokyonight"
    && cfg.${target}.enable
    && pkgs.stdenv.hostPlatform.isLinux
    && (config.programs.niri.enable or false);
in
{
  config = lib.mkIf enable {
    programs.niri.settings.layout = {
      background-color = palette.bg;
      border = {
        active.color = palette.magenta;
        inactive.color = palette.bg_highlight;
        urgent.color = palette.red;
      };
      focus-ring = {
        active.gradient = {
          from = palette.blue;
          to = palette.magenta;
          angle = 45;
          in' = "oklch longer hue";
        };
        inactive.color = palette.bg_dark;
        urgent.color = palette.yellow;
      };
    };
  };
}
