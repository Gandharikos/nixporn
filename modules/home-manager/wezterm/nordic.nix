{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.nordic.palette) ansi;
  target = "wezterm";
  enable = cfg.enable && cfg.colorscheme == "nordic" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.wezterm.extraConfig = ''
      config.colors = {
        foreground = "${ansi.fg}",
        background = "${ansi.bg}",
        ansi = { "${ansi.black}", "${ansi.red}", "${ansi.green}", "${ansi.yellow}", "${ansi.blue}", "${ansi.magenta}", "${ansi.cyan}", "${ansi.white}" },
        brights = { "${ansi.bright_black}", "${ansi.bright_red}", "${ansi.bright_green}", "${ansi.bright_yellow}", "${ansi.bright_blue}", "${ansi.bright_magenta}", "${ansi.bright_cyan}", "${ansi.bright_white}" },
      }
    '';
  };
}
