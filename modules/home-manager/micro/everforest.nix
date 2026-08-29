{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) everforest;
  source = pkgs.nixporn.everforest.micro;
  target = "micro";
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.${target}.enable;
  useNativeTheme = everforest.mode == "dark" && everforest.contrast == "medium";
in
{
  config = lib.mkIf enable {
    programs.micro.settings.colorscheme = if useNativeTheme then "everforest" else "simple";
    xdg.configFile = lib.mkIf useNativeTheme {
      "micro/colorschemes/everforest.micro".source = "${source}/everforest.micro";
    };
  };
}
