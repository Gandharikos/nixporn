{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (config.nixporn.colorscheme) palette;
  cfg = config.nixporn.catppuccin;
  targetCfg = config.nixporn.targets."niri";
  enable = cfg.enable && targetCfg.enable && isLinux && (config.programs.niri.enable or false);
  accent = palette.${cfg.accent};
in
{
  config = mkIf enable {
    programs.niri.settings.layout = {
      background-color = palette.base.bg;
      border = {
        active.color = accent;
        inactive.color = palette.surface0;
        urgent.color = palette.red;
      };
      focus-ring = {
        active.color = accent;
        inactive.color = palette.surface0;
        urgent.color = palette.red;
      };
    };
  };
}
