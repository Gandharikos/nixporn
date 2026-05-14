{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.gruvbox) palette;
  inherit (palette) ansi;
  target = "alacritty";
  enable = cfg.enable && cfg.colorscheme == "gruvbox" && cfg.${target}.enable;
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
