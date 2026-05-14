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
  target = "bat";
  supported = {
    dark = "dark-decay";
    decayce = "decayce";
  };
  enable =
    cfg.enable
    && cfg.colorscheme == "decay"
    && cfg.${target}.enable
    && builtins.hasAttr variant supported;
  themeName = supported.${variant};
in
{
  config = lib.mkIf enable {
    programs.bat = {
      config.theme = themeName;
      themes.${themeName} = {
        src = sources.bat;
        file = "themes/${themeName}.tmTheme";
      };
    };
  };
}
