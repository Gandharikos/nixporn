{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) variant;
  sources = pkgs.nixporn.rose-pine;
  target = "obs";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  themeName = "RosePine_${if variant == "main" then "Main" else lib.toSentenceCase variant}.ovt";
in
{
  config = lib.mkIf enable {
    xdg.configFile = {
      "obs-studio/themes/RosePine.obt".source = "${sources.obs}/themes/RosePine.obt";
      "obs-studio/themes/${themeName}".source = "${sources.obs}/themes/${themeName}";
    };
  };
}
