{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "zed-editor";
  colorscheme = cfg.colorscheme;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific && config.programs.zed-editor.enable;
  inherit (cfg.palette) ansi;
  themeName = "Nixporn ${colorschemeCfg.slug}";
  themeFile = "nixporn-${colorschemeCfg.slug}";
  italic = if cfg.${target}.italics then "italic" else null;

  syntax = color: {
    inherit color;
    background_color = null;
    font_style = null;
    font_weight = null;
  };
in
{
  config = lib.mkIf enable {
    programs.zed-editor = {
      userSettings.theme = {
        mode = colorschemeCfg.polarity;
        light = themeName;
        dark = themeName;
      };

      themes.${themeFile} = {
        "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
        name = themeName;
        author = "nixporn";
        themes = [
          {
            name = themeName;
            appearance = colorschemeCfg.polarity;
            style = {
              "background.appearance" = "opaque";
              accents = [
                ansi.blue
                ansi.cyan
                ansi.green
                ansi.yellow
                ansi.magenta
                ansi.red
              ];

              border = ansi.black;
              "border.variant" = ansi.black;
              "border.focused" = ansi.blue;
              "border.selected" = ansi.blue;
              "border.transparent" = "#00000000";
              "border.disabled" = ansi.bright_black;

              background = ansi.bg;
              "surface.background" = ansi.black;
              "elevated_surface.background" = ansi.black;
              "panel.background" = ansi.bg;
              "status_bar.background" = ansi.black;
              "title_bar.background" = ansi.black;
              "title_bar.inactive_background" = ansi.bg;
              "toolbar.background" = ansi.bg;
              "tab_bar.background" = ansi.black;
              "tab.inactive_background" = ansi.black;
              "tab.active_background" = ansi.bg;

              "element.background" = ansi.black;
              "element.hover" = ansi.bright_black;
              "element.active" = ansi.bright_black;
              "element.selected" = "${ansi.blue}33";
              "element.disabled" = ansi.black;
              "drop_target.background" = "${ansi.blue}55";
              "ghost_element.background" = "#00000000";
              "ghost_element.hover" = "${ansi.bright_black}66";
              "ghost_element.active" = "${ansi.bright_black}99";
              "ghost_element.selected" = "${ansi.blue}44";
              "ghost_element.disabled" = ansi.bright_black;

              text = ansi.fg;
              "text.muted" = ansi.white;
              "text.placeholder" = ansi.bright_black;
              "text.disabled" = ansi.bright_black;
              "text.accent" = ansi.blue;
              icon = ansi.fg;
              "icon.muted" = ansi.white;
              "icon.disabled" = ansi.bright_black;
              "icon.placeholder" = ansi.bright_black;
              "icon.accent" = ansi.blue;

              "scrollbar.thumb.background" = "${ansi.bright_black}80";
              "scrollbar.thumb.hover_background" = ansi.bright_black;
              "scrollbar.track.background" = "#00000000";
              "scrollbar.track.border" = "${ansi.black}80";

              "editor.foreground" = ansi.fg;
              "editor.background" = ansi.bg;
              "editor.gutter.background" = ansi.bg;
              "editor.subheader.background" = ansi.black;
              "editor.active_line.background" = "${ansi.black}80";
              "editor.highlighted_line.background" = "${ansi.black}66";
              "editor.line_number" = ansi.bright_black;
              "editor.active_line_number" = ansi.blue;
              "editor.invisible" = "${ansi.bright_black}99";
              "editor.wrap_guide" = "${ansi.bright_black}66";
              "editor.active_wrap_guide" = ansi.bright_black;
              "editor.indent_guide" = "${ansi.bright_black}66";
              "editor.indent_guide_active" = ansi.bright_black;
              "editor.document_highlight.read_background" = "${ansi.blue}22";
              "editor.document_highlight.write_background" = "${ansi.yellow}22";

              "terminal.background" = ansi.bg;
              "terminal.foreground" = ansi.fg;
              "terminal.bright_foreground" = ansi.bright_white;
              "terminal.dim_foreground" = ansi.bright_black;
              "terminal.ansi.black" = ansi.black;
              "terminal.ansi.red" = ansi.red;
              "terminal.ansi.green" = ansi.green;
              "terminal.ansi.yellow" = ansi.yellow;
              "terminal.ansi.blue" = ansi.blue;
              "terminal.ansi.magenta" = ansi.magenta;
              "terminal.ansi.cyan" = ansi.cyan;
              "terminal.ansi.white" = ansi.white;
              "terminal.ansi.bright_black" = ansi.bright_black;
              "terminal.ansi.bright_red" = ansi.bright_red;
              "terminal.ansi.bright_green" = ansi.bright_green;
              "terminal.ansi.bright_yellow" = ansi.bright_yellow;
              "terminal.ansi.bright_blue" = ansi.bright_blue;
              "terminal.ansi.bright_magenta" = ansi.bright_magenta;
              "terminal.ansi.bright_cyan" = ansi.bright_cyan;
              "terminal.ansi.bright_white" = ansi.bright_white;

              "link_text.hover" = ansi.blue;
              error = ansi.red;
              "error.background" = "${ansi.red}22";
              "error.border" = ansi.red;
              warning = ansi.yellow;
              "warning.background" = "${ansi.yellow}22";
              "warning.border" = ansi.yellow;
              info = ansi.blue;
              "info.background" = "${ansi.blue}22";
              "info.border" = ansi.blue;
              hint = ansi.cyan;
              "hint.background" = "${ansi.cyan}22";
              "hint.border" = ansi.cyan;
              success = ansi.green;
              "success.background" = "${ansi.green}22";
              "success.border" = ansi.green;
              created = ansi.green;
              "created.background" = "${ansi.green}22";
              "created.border" = ansi.green;
              deleted = ansi.red;
              "deleted.background" = "${ansi.red}22";
              "deleted.border" = ansi.red;
              modified = ansi.yellow;
              "modified.background" = "${ansi.yellow}22";
              "modified.border" = ansi.yellow;
              ignored = ansi.bright_black;
              "ignored.background" = ansi.bg;
              "ignored.border" = ansi.black;

              "version_control.added" = ansi.green;
              "version_control.deleted" = ansi.red;
              "version_control.modified" = ansi.yellow;
              "version_control.conflict" = ansi.magenta;
              "version_control.renamed" = ansi.blue;
              "version_control.ignored" = ansi.bright_black;

              players = [
                {
                  cursor = ansi.blue;
                  background = ansi.blue;
                  selection = "${ansi.blue}33";
                }
                {
                  cursor = ansi.green;
                  background = ansi.green;
                  selection = "${ansi.green}33";
                }
                {
                  cursor = ansi.magenta;
                  background = ansi.magenta;
                  selection = "${ansi.magenta}33";
                }
              ];

              syntax = {
                attribute = syntax ansi.cyan;
                boolean = syntax ansi.magenta;
                comment = (syntax ansi.bright_black) // {
                  font_style = italic;
                };
                "comment.doc" = (syntax ansi.bright_black) // {
                  font_style = italic;
                };
                constant = syntax ansi.magenta;
                constructor = syntax ansi.cyan;
                emphasis = (syntax ansi.yellow) // {
                  font_style = italic;
                };
                "emphasis.strong" = (syntax ansi.yellow) // {
                  font_weight = 700;
                };
                function = syntax ansi.blue;
                keyword = syntax ansi.magenta;
                label = syntax ansi.cyan;
                link_uri = syntax ansi.blue;
                number = syntax ansi.yellow;
                operator = syntax ansi.cyan;
                predictive = syntax ansi.bright_black;
                preproc = syntax ansi.magenta;
                primary = syntax ansi.fg;
                property = syntax ansi.blue;
                punctuation = syntax ansi.white;
                string = syntax ansi.green;
                "string.escape" = syntax ansi.cyan;
                tag = syntax ansi.red;
                text = syntax ansi.fg;
                title = syntax ansi.blue;
                type = syntax ansi.yellow;
                variable = syntax ansi.fg;
                "variable.special" = syntax ansi.red;
              };
            };
          }
        ];
      };
    };
  };
}
