{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "hyprland";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
  rgb = color: "rgb(${hex color})";
  rgba = color: alpha: "rgba(${hex color}${alpha})";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      wayland.windowManager.hyprland.settings = {
        decoration.shadow.color = rgba ansi.bg "99";
        general = {
          "col.active_border" = rgb ansi.blue;
          "col.inactive_border" = rgb ansi.bright_black;
        };
        group = {
          "col.border_active" = rgb ansi.blue;
          "col.border_inactive" = rgb ansi.bright_black;
          "col.border_locked_active" = rgb ansi.cyan;
          groupbar = {
            text_color = rgb ansi.fg;
            "col.active" = rgb ansi.blue;
            "col.inactive" = rgb ansi.black;
          };
        };
        misc.background_color = rgb ansi.bg;
      };
    }
  );
}
