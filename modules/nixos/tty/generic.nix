{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  target = "tty";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (./. + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  color = name: lib.removePrefix "#" cfg.palette.ansi.${name};
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
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
    }
  );
}
