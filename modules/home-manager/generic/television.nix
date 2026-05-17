{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "television";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = "nixporn-${cfg.colorschemes.${colorscheme}.slug}";
in
{
  config = lib.mkIf enable {
    programs.television.settings.ui.theme = themeName;
    xdg.configFile."television/themes/${themeName}.toml".text = ''
      # general
      background = '${ansi.bg}'
      border_fg = '${ansi.black}'
      text_fg = '${ansi.fg}'
      dimmed_text_fg = '${ansi.bright_black}'
      # input
      input_text_fg = '${ansi.blue}'
      result_count_fg = '${ansi.blue}'
      # results
      result_name_fg = '${ansi.blue}'
      result_line_number_fg = '${ansi.yellow}'
      result_value_fg = '${ansi.magenta}'
      selection_fg = '${ansi.green}'
      selection_bg = '${ansi.black}'
      match_fg = '${ansi.green}'
      # preview
      preview_title_fg = '${ansi.blue}'
      # modes
      channel_mode_fg = '${ansi.bg}'
      channel_mode_bg = '${ansi.blue}'
      remote_control_mode_fg = '${ansi.bg}'
      remote_control_mode_bg = '${ansi.green}'
    '';
  };
}
