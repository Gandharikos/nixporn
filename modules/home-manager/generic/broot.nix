{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "broot";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.broot.settings = {
      imports = [ ];

      skin = {
        default = "${ansi.fg} ${ansi.bg}";
        tree = "${ansi.bright_black} ${ansi.bg}";
        parent = "${ansi.bright_black} ${ansi.bg}";
        file = "${ansi.fg} ${ansi.bg}";
        directory = "${ansi.blue} ${ansi.bg} Bold";
        exe = "${ansi.green} ${ansi.bg}";
        link = "${ansi.cyan} ${ansi.bg}";
        pruning = "${ansi.bright_black} ${ansi.bg} Italic";
        perm__ = "${ansi.bright_black} ${ansi.bg}";
        perm_r = "${ansi.cyan} ${ansi.bg}";
        perm_w = "${ansi.yellow} ${ansi.bg}";
        perm_x = "${ansi.green} ${ansi.bg}";
        owner = "${ansi.bright_white} ${ansi.bg}";
        group = "${ansi.magenta} ${ansi.bg}";
        count = "${ansi.yellow} ${ansi.bg}";
        dates = "${ansi.cyan} ${ansi.bg}";
        sparse = "${ansi.yellow} ${ansi.bg}";
        content_extract = "${ansi.cyan} ${ansi.bg}";
        content_match = "${ansi.green} ${ansi.bg}";
        device_id_major = "${ansi.bright_white} ${ansi.bg}";
        device_id_sep = "${ansi.bright_black} ${ansi.bg}";
        device_id_minor = "${ansi.bright_white} ${ansi.bg}";

        git_branch = "${ansi.magenta} ${ansi.bg}";
        git_insertions = "${ansi.green} ${ansi.bg}";
        git_deletions = "${ansi.red} ${ansi.bg}";
        git_status_current = "${ansi.fg} ${ansi.bg}";
        git_status_modified = "${ansi.yellow} ${ansi.bg}";
        git_status_new = "${ansi.cyan} ${ansi.bg} Bold";
        git_status_ignored = "${ansi.bright_black} ${ansi.bg}";
        git_status_conflicted = "${ansi.red} ${ansi.bg}";
        git_status_other = "${ansi.red} ${ansi.bg}";

        selected_line = "none ${ansi.black}";
        char_match = "${ansi.green} ${ansi.bg} Bold";
        file_error = "${ansi.red} ${ansi.bg}";

        flag_label = "${ansi.fg} ${ansi.bg}";
        flag_value = "${ansi.blue} ${ansi.bg} Bold";

        input = "${ansi.fg} ${ansi.bg}";

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

        scrollbar_track = "${ansi.bright_black} ${ansi.bg}";
        scrollbar_thumb = "${ansi.black} ${ansi.bg}";

        help_paragraph = "${ansi.fg} ${ansi.bg}";
        help_bold = "${ansi.magenta} ${ansi.bg} Bold";
        help_italic = "${ansi.red} ${ansi.bg} Italic";
        help_code = "${ansi.fg} ${ansi.bright_black}";
        help_headers = "${ansi.magenta} ${ansi.bg}";
        help_table_border = "${ansi.bright_black} ${ansi.bg}";

        preview_title = "${ansi.fg} ${ansi.bg}";
        preview = "${ansi.fg} ${ansi.black}";
        preview_separator = "${ansi.magenta} ${ansi.bg}";
        preview_line_number = "${ansi.fg} ${ansi.black}";
        preview_match = "none ${ansi.green}";

        hex_null = "${ansi.bright_black} ${ansi.bg}";
        hex_ascii_graphic = "${ansi.black} ${ansi.bg}";
        hex_ascii_whitespace = "${ansi.yellow} ${ansi.bg}";
        hex_ascii_other = "${ansi.yellow} ${ansi.bg}";
        hex_non_ascii = "${ansi.red} ${ansi.bg}";

        staging_area_title = "${ansi.fg} ${ansi.bg}";
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
