{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "dunst";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
in
{
  config = lib.mkIf enable {
    xdg.configFile."dunst/dunstrc.d/${cfg.dunst.prefix}-${themeName}.conf".text = ''
      [global]
      background = "${ansi.bg}"
      foreground = "${ansi.fg}"
      frame_color = "${ansi.blue}"
      highlight = "${ansi.cyan}"

      [urgency_low]
      background = "${ansi.bg}"
      foreground = "${ansi.fg}"

      [urgency_normal]
      background = "${ansi.bg}"
      foreground = "${ansi.fg}"

      [urgency_critical]
      background = "${ansi.bg}"
      foreground = "${ansi.red}"
      frame_color = "${ansi.red}"
    '';
  };
}
