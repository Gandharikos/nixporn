{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) cyberdream;
  inherit (cyberdream) slug;
  source = pkgs.nixporn.cyberdream;
  target = "bat";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
  themeName = if cyberdream.variant == "light" then "Cyberdream Light" else "Cyberdream";
in
{
  config = lib.mkIf enable {
    programs.bat = {
      config.theme = themeName;
      themes.${themeName} = {
        src = source;
        file = "extras/textmate/${slug}.tmTheme";
      };
    };
  };
}
