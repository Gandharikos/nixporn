{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "cava";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
in
{
  config = lib.mkIf enable {
    xdg.configFile."cava/themes/${themeName}".text = ''
      [color]
      gradient = 1
      gradient_color_1 = '${ansi.blue}'
      gradient_color_2 = '${ansi.cyan}'
      gradient_color_3 = '${ansi.green}'
      gradient_color_4 = '${ansi.yellow}'
      gradient_color_5 = '${ansi.red}'
    '';
    programs.cava.settings.color.theme = themeName;
  };
}
