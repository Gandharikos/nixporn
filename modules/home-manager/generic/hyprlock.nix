{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "hyprlock";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
  rgb = color: "rgb(${hex color})";
in
{
  config = lib.mkIf enable {
    programs.hyprlock.settings = {
      background.color = rgb ansi.bg;
      input-field = {
        outer_color = rgb ansi.bright_black;
        inner_color = rgb ansi.bg;
        font_color = rgb ansi.fg;
        fail_color = rgb ansi.red;
        check_color = rgb ansi.yellow;
      };
    };
  };
}
