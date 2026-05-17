{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "mpv";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
in
{
  config = lib.mkIf enable {
    programs.mpv = {
      config = {
        background-color = "#000000";
        osd-back-color = ansi.black;
        osd-border-color = ansi.black;
        osd-color = ansi.fg;
        osd-shadow-color = ansi.bg;
      };
      scriptOpts = {
        uosc.color = "background=${hex ansi.bg},background_text=${hex ansi.fg},foreground=${hex ansi.fg},foreground_text=${hex ansi.bg},success=${hex ansi.green},error=${hex ansi.red}";
        modernz = {
          seekbarfg_color = ansi.blue;
          seekbarbg_color = ansi.bright_black;
          seekbar_cache_color = ansi.bright_black;
          window_title_color = ansi.bright_black;
          window_controls_color = ansi.bright_black;
          title_color = ansi.fg;
          time_color = ansi.fg;
          chapter_title_color = ansi.fg;
          cache_info_color = ansi.fg;
          middle_buttons_color = ansi.blue;
          side_buttons_color = ansi.bright_black;
          playpause_color = ansi.blue;
          hover_effect_color = ansi.magenta;
        };
      };
    };
  };
}
