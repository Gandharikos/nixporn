{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.decay) palette;
  target = "cava";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."cava/themes/decay".text = ''
      [color]
      gradient = 1
      gradient_color_1 = '${palette.blue}'
      gradient_color_2 = '${palette.lavender}'
      gradient_color_3 = '${palette.magenta}'
      gradient_color_4 = '${palette.red}'
    '';
    programs.cava.settings.color.theme = "decay";
  };
}
