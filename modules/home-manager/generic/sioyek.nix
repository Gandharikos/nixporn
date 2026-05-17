{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "sioyek";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.sioyek.config = {
      startup_commands = [ "toggle_custom_color" ];
      background_color = ansi.bg;
      text_highlight_color = ansi.yellow;
      visual_mark_color = ansi.black;
      search_highlight_color = ansi.yellow;
      link_highlight_color = ansi.blue;
      synctex_highlight_color = ansi.green;
      highlight_color_a = ansi.yellow;
      highlight_color_b = ansi.green;
      highlight_color_c = ansi.blue;
      highlight_color_d = ansi.red;
      highlight_color_e = ansi.magenta;
      highlight_color_f = ansi.cyan;
      highlight_color_g = ansi.yellow;
      custom_background_color = ansi.bg;
      custom_text_color = ansi.fg;
      ui_text_color = ansi.fg;
      ui_background_color = ansi.black;
      ui_selected_text_color = ansi.fg;
      ui_selected_background_color = ansi.bright_black;
      status_bar_color = ansi.black;
      status_bar_text_color = ansi.fg;
    };
  };
}
