{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg) palette;
  inherit (cfg.colorschemes) catppuccin;
  target = "niri";
  hasProgram = options.programs ? niri;
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && pkgs.stdenv.hostPlatform.isLinux
    && (config.programs.niri.enable or false);
  accent = palette.${catppuccin.accent};
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.niri.settings.layout = {
        background-color = palette.base;
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
    }
  );
}
