{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "niri";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable =
    cfg.enable
    && cfg.${target}.enable
    && !hasSpecific
    && pkgs.stdenv.hostPlatform.isLinux
    && (config.programs.niri.enable or false);
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.niri.settings.layout = {
        background-color = ansi.bg;
        border = {
          active.color = ansi.blue;
          inactive.color = ansi.black;
          urgent.color = ansi.red;
        };
        focus-ring = {
          active.gradient = {
            from = ansi.blue;
            to = ansi.magenta;
            angle = 45;
            in' = "oklch longer hue";
          };
          inactive.color = ansi.black;
          urgent.color = ansi.yellow;
        };
      };
    }
  );
}
