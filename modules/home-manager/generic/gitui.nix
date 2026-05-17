{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "gitui";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.gitui.theme = ''
      (
          selected_tab: Some("Reset"),
          command_fg: Some("${ansi.fg}"),
          selection_bg: Some("${ansi.black}"),
          selection_fg: Some("${ansi.fg}"),
          cmdbar_bg: Some("${ansi.bg}"),
          cmdbar_extra_lines_bg: Some("${ansi.bg}"),
          disabled_fg: Some("${ansi.bright_black}"),
          diff_line_add: Some("${ansi.green}"),
          diff_line_delete: Some("${ansi.red}"),
          diff_file_added: Some("${ansi.green}"),
          diff_file_removed: Some("${ansi.red}"),
          diff_file_moved: Some("${ansi.magenta}"),
          diff_file_modified: Some("${ansi.yellow}"),
          commit_hash: Some("${ansi.bright_white}"),
          commit_time: Some("${ansi.fg}"),
          commit_author: Some("${ansi.blue}"),
          danger_fg: Some("${ansi.red}"),
          push_gauge_bg: Some("${ansi.blue}"),
          push_gauge_fg: Some("${ansi.bg}"),
          tag_fg: Some("${ansi.cyan}"),
          branch_fg: Some("${ansi.cyan}")
      )
    '';
  };
}
