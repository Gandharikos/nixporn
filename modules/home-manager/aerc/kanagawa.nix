{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) slug variant;
  colors = import ../generic/kanagawa-colors.nix {
    inherit (cfg) palette;
    inherit variant;
  };
  target = "aerc";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  styleset = ''
    *.default=true
    ${lib.optionalString (!cfg.transparent) "default.bg=${colors.bg}"}

    title.reverse=true
    header.bold=true
    header.fg=${colors.fg}

    *error.bold=true
    error.fg=${colors.builtin}
    warning.fg=${colors.warning}
    success.fg=${colors.string}

    statusline*.default=true
    statusline_error.fg=${colors.builtin}
    statusline_default.fg=${colors.warning}
    ${lib.optionalString (!cfg.transparent) "statusline_default.bg=${colors.bg}"}

    dirlist_recent.selected.fg=${colors.bgHighlight}
    dirlist_unread.fg=${colors.special}
    dirlist_unread.selected.fg=${colors.special}
    dirlist_default.selected.bg=${colors.bgHighlight}
    dirlist_default.selected.fg=${colors.fg}

    msglist_default.selected.fg=${colors.bgHighlight}
    msglist_default.selected.bg=${colors.warning}
    msglist_unread.bold=true
    msglist_unread.fg=${colors.special}
    msglist_unread.selected.bg=${colors.bgHighlight}
    msglist_read.selected.fg=${colors.fg}
    msglist_read.selected.bg=${colors.bgHighlight}
    msglist_marked.fg=${colors.warning}
    msglist_marked.selected.fg=${colors.fg}
    msglist_marked.selected.bg=${colors.bgHighlight}
    msglist_deleted.fg=${colors.error}
    msglist_result.fg=${colors.fg}
    msglist_result.selected.bg=${colors.bgHighlight}

    msglist_deleted.selected.reverse=toggle
    completion_pill.reverse=true

    tab.reverse=true
    border.reverse=true
    tab.bg=${colors.warning}
    tab.fg=${colors.bgHighlight}
    tab.selected.bg=${colors.bgHighlight}
    tab.selected.fg=${colors.warning}
    border.fg=${colors.bgHighlight}

    selector_focused.reverse=true
    selector_chooser.bold=true
  '';
in
{
  # Ported from https://github.com/rebelot/kanagawa.nvim/pull/236.
  config = lib.mkIf enable {
    programs.aerc = {
      stylesets.${slug} = styleset;
      extraConfig.ui = {
        styleset-name = slug;
        border-char-vertical = "│";
        border-char-horizontal = "─";
      };
    };
  };
}
