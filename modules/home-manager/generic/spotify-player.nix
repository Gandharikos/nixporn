{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "spotify-player";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = "nixporn-${colorscheme}";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.spotify-player = {
        settings.theme = themeName;
        themes = [
          {
            name = themeName;
            palette = {
              background = ansi.bg;
              foreground = ansi.fg;
              black = ansi.black;
              red = ansi.red;
              green = ansi.green;
              yellow = ansi.yellow;
              blue = ansi.blue;
              magenta = ansi.magenta;
              cyan = ansi.cyan;
              white = ansi.white;
              bright_black = ansi.bright_black;
              bright_red = ansi.bright_red;
              bright_green = ansi.bright_green;
              bright_yellow = ansi.bright_yellow;
              bright_blue = ansi.bright_blue;
              bright_magenta = ansi.bright_magenta;
              bright_cyan = ansi.bright_cyan;
              bright_white = ansi.bright_white;
            };
          }
        ];
      };
    }
  );
}
