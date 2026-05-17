{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "spotify-player";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
in
{
  config = lib.mkIf enable {
    programs.spotify-player = {
      settings.theme = themeName;
      themes = [
        {
          name = themeName;
          palette = {
            background = ansi.bg;
            foreground = ansi.fg;
            inherit (ansi)
              black
              red
              green
              yellow
              blue
              magenta
              cyan
              white
              bright_black
              bright_red
              bright_green
              bright_yellow
              bright_blue
              bright_magenta
              bright_cyan
              bright_white
              ;
          };
        }
      ];
    };
  };
}
