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
  target = "mako";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable;
  themeDirectory =
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
    services.mako.settings.include = "${sources.mako}/configs/${themeDirectory}/config";
  };
}
