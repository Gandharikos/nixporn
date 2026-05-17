{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "broot";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  bg = if cfg.transparent then "none" else ansi.bg;
in
{
  config = lib.mkIf enable {
    programs.broot.settings = {
      imports = [ ];

      skin = {
        default = "${ansi.fg} ${bg}";
        tree = "${ansi.bright_black} ${bg}";
        parent = "${ansi.bright_black} ${bg}";
        file = "${ansi.fg} ${bg}";
        directory = "${ansi.blue} ${bg} Bold";
        exe = "${ansi.green} ${bg}";
        link = "${ansi.cyan} ${bg}";
        pruning = "${ansi.bright_black} ${bg} Italic";
        perm__ = "${ansi.bright_black} ${bg}";
        perm_r = "${ansi.cyan} ${bg}";
        perm_w = "${ansi.yellow} ${bg}";
        perm_x = "${ansi.green} ${bg}";
        owner = "${ansi.bright_white} ${bg}";
        group = "${ansi.magenta} ${bg}";
        count = "${ansi.yellow} ${bg}";
        dates = "${ansi.cyan} ${bg}";
        sparse = "${ansi.yellow} ${bg}";
        content_extract = "${ansi.cyan} ${bg}";
        content_match = "${ansi.green} ${bg}";
        device_id_major = "${ansi.bright_white} ${bg}";
        device_id_sep = "${ansi.bright_black} ${bg}";
        device_id_minor = "${ansi.bright_white} ${bg}";

        git_branch = "${ansi.magenta} ${bg}";
        git_insertions = "${ansi.green} ${bg}";
        git_deletions = "${ansi.red} ${bg}";
        git_status_current = "${ansi.fg} ${bg}";
        git_status_modified = "${ansi.yellow} ${bg}";
        git_status_new = "${ansi.cyan} ${bg} Bold";
        git_status_ignored = "${ansi.bright_black} ${bg}";
        git_status_conflicted = "${ansi.red} ${bg}";
        git_status_other = "${ansi.red} ${bg}";

        selected_line = "none ${ansi.black}";
        char_match = "${ansi.green} ${bg} Bold";
        file_error = "${ansi.red} ${bg}";

        flag_label = "${ansi.fg} ${bg}";
        flag_value = "${ansi.blue} ${bg} Bold";

        input = "${ansi.fg} ${bg}";

        status_error = "${ansi.bright_black} ${ansi.black}";
        status_job = "${ansi.yellow} ${ansi.black}";
        status_normal = "${ansi.bright_black} ${ansi.black}";
        status_italic = "${ansi.blue} ${ansi.black} Italic";
        status_bold = "${ansi.magenta} ${ansi.black} Bold";
        status_code = "${ansi.yellow} ${ansi.black}";
        status_ellipsis = "${ansi.fg} ${ansi.black}";

        purpose_normal = "${ansi.fg} ${ansi.black}";
        purpose_italic = "${ansi.yellow} ${ansi.black} Italic";
        purpose_bold = "${ansi.yellow} ${ansi.black} Bold";
        purpose_ellipsis = "${ansi.fg} ${ansi.black}";

        scrollbar_track = "${ansi.bright_black} ${bg}";
        scrollbar_thumb = "${ansi.black} ${bg}";

        help_paragraph = "${ansi.fg} ${bg}";
        help_bold = "${ansi.magenta} ${bg} Bold";
        help_italic = "${ansi.red} ${bg} Italic";
        help_code = "${ansi.fg} ${ansi.bright_black}";
        help_headers = "${ansi.magenta} ${bg}";
        help_table_border = "${ansi.bright_black} ${bg}";

        preview_title = "${ansi.fg} ${bg}";
        preview = "${ansi.fg} ${ansi.black}";
        preview_separator = "${ansi.magenta} ${bg}";
        preview_line_number = "${ansi.fg} ${ansi.black}";
        preview_match = "none ${ansi.green}";

        hex_null = "${ansi.bright_black} ${bg}";
        hex_ascii_graphic = "${ansi.black} ${bg}";
        hex_ascii_whitespace = "${ansi.yellow} ${bg}";
        hex_ascii_other = "${ansi.yellow} ${bg}";
        hex_non_ascii = "${ansi.red} ${bg}";

        staging_area_title = "${ansi.fg} ${bg}";
        mode_command_mark = "${ansi.bright_black} ${ansi.red} Bold";

        good_to_bad_0 = ansi.green;
        good_to_bad_1 = ansi.green;
        good_to_bad_2 = ansi.cyan;
        good_to_bad_3 = ansi.blue;
        good_to_bad_4 = ansi.yellow;
        good_to_bad_5 = ansi.yellow;
        good_to_bad_6 = ansi.yellow;
        good_to_bad_7 = ansi.magenta;
        good_to_bad_8 = ansi.red;
        good_to_bad_9 = ansi.red;
      };
    };
  };
}
