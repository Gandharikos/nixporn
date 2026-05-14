{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.gruvbox.palette) ansi;
  target = "kitty";
  enable = cfg.enable && cfg.colorscheme == "gruvbox" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.kitty.extraConfig = lib.mkBefore ''
      foreground ${ansi.fg}
      background ${ansi.bg}
      color0 ${ansi.black}
      color1 ${ansi.red}
      color2 ${ansi.green}
      color3 ${ansi.yellow}
      color4 ${ansi.blue}
      color5 ${ansi.magenta}
      color6 ${ansi.cyan}
      color7 ${ansi.white}
      color8 ${ansi.bright_black}
      color9 ${ansi.bright_red}
      color10 ${ansi.bright_green}
      color11 ${ansi.bright_yellow}
      color12 ${ansi.bright_blue}
      color13 ${ansi.bright_magenta}
      color14 ${ansi.bright_cyan}
      color15 ${ansi.bright_white}
    '';
  };
}
