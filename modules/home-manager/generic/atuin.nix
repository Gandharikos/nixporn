{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "atuin";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
in
{
  config = lib.mkIf enable {
    programs.atuin = {
      settings.theme.name = themeName;
      themes.${themeName} = {
        theme.name = themeName;
        colors = {
          AlertInfo = ansi.green;
          AlertWarn = ansi.yellow;
          AlertError = ansi.red;
          Annotation = ansi.magenta;
          Base = ansi.fg;
          Guidance = ansi.bright_black;
          Important = ansi.red;
          Title = ansi.magenta;
        };
      };
    };
  };
}
