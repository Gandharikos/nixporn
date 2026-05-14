{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  target = "tty";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  color = name: lib.removePrefix "#" rose-pine.palette.ansi.${name};
in
{
  config = lib.mkIf enable {
    console.colors = map color [
      "black"
      "red"
      "green"
      "yellow"
      "blue"
      "magenta"
      "cyan"
      "white"
      "bright_black"
      "bright_red"
      "bright_green"
      "bright_yellow"
      "bright_blue"
      "bright_magenta"
      "bright_cyan"
      "bright_white"
    ];
  };
}
