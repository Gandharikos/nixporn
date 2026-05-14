{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) decay;
  inherit (decay) variant;
  sources = pkgs.nixporn.decay;
  target = "dunst";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable;
  themeFile =
    {
      cosmic = "decay";
      dark = "darkdecay";
      decayce = "decayce";
      default = "decay";
      light = "lightdecay";
    }
    .${variant};
in
{
  config = lib.mkIf enable {
    xdg.configFile."dunst/dunstrc.d/${cfg.${target}.prefix}-decay.conf".source =
      "${sources.dunst}/src/${themeFile}-dunstrc";
  };
}
