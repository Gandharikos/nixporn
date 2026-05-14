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
  target = "polybar";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable;
  themeFile =
    {
      cosmic = "decay";
      dark = "dark-decay";
      decayce = "decayce";
      default = "decay";
      light = "light-decay";
    }
    .${variant};
in
{
  config = lib.mkIf enable {
    services.polybar.extraConfig = lib.fileContents "${sources.polybar}/themes/${themeFile}.ini";
  };
}
