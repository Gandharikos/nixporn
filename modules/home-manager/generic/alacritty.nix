{ targetPath }:
{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  target = "alacritty";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.alacritty.settings.colors = {
      primary = {
        background = ansi.bg;
        foreground = ansi.fg;
      };
      normal = {
        inherit (ansi)
          black
          blue
          cyan
          green
          magenta
          red
          white
          yellow
          ;
      };
      bright = {
        black = ansi.bright_black;
        blue = ansi.bright_blue;
        cyan = ansi.bright_cyan;
        green = ansi.bright_green;
        magenta = ansi.bright_magenta;
        red = ansi.bright_red;
        white = ansi.bright_white;
        yellow = ansi.bright_yellow;
      };
    };
  };
}
