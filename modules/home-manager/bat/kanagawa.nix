{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  source = pkgs.nixporn.kanagawa;
  target = "bat";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  themeName = "kanagawa";
in
{
  config = lib.mkIf enable {
    programs.bat = {
      config.theme = themeName;
      themes.${themeName} = {
        src = source;
        file = "extras/tmTheme/kanagawa.tmTheme";
      };
    };
  };
}
