{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "obs";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  inherit (cfg.palette) ansi;
  themeName = "Nixporn_${colorschemeCfg.slug}";
  isDark = colorschemeCfg.polarity == "dark";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      xdg.configFile."obs-studio/themes/${themeName}.ovt".text = ''
        @OBSThemeMeta {
            name: '${themeName}';
            id: 'dev.nixporn.${colorschemeCfg.slug}';
            extends: 'com.obsproject.Yami';
            author: 'nixporn';
            dark: '${if isDark then "true" else "false"}';
        }

        @OBSThemeVars {
            --bg_window:  ${ansi.black};
            --bg_base:    ${ansi.bg};
            --bg_preview: ${ansi.black};

            --primary:         ${ansi.blue};
            --primary_light:   ${ansi.bright_blue};
            --primary_lighter: ${ansi.bright_blue};
            --primary_dark:    ${ansi.blue};
            --primary_darker:  ${ansi.cyan};

            --warning: ${ansi.yellow};
            --danger:  ${ansi.red};

            --text:          ${ansi.fg};
            --text_light:    ${ansi.white};
            --text_muted:    ${ansi.bright_black};
            --text_disabled: ${ansi.bright_black};
            --text_inactive: ${ansi.white};

            --scrollbar_bg:     ${ansi.bg};
            --scrollbar_handle: ${ansi.black};
            --scrollbar_hover:  ${ansi.bright_black};
            --scrollbar_down:   ${ansi.bright_black};
            --scrollbar_border: ${ansi.black};

            --border_color: ${ansi.black};

            --input_bg:       ${ansi.black};
            --input_bg_hover: ${ansi.bg};
            --input_bg_focus: ${ansi.bg};

            --input_border:       ${ansi.black};
            --input_border_hover: ${ansi.bright_black};
            --input_border_focus: ${ansi.blue};

            --list_item_bg_hover: ${ansi.black};

            --button_bg:          ${ansi.black};
            --button_bg_hover:    ${ansi.bright_black};
            --button_bg_down:     ${ansi.bg};
            --button_bg_disabled: ${ansi.bg};

            --button_border:       ${ansi.black};
            --button_border_hover: ${ansi.bright_black};
            --button_border_focus: ${ansi.blue};

            --tab_bg:          ${ansi.bg};
            --tab_bg_hover:    ${ansi.black};
            --tab_bg_down:     ${ansi.black};
            --tab_bg_disabled: ${ansi.bg};

            --tab_border:          ${ansi.bright_black};
            --tab_border_hover:    ${ansi.bright_black};
            --tab_border_focus:    ${ansi.blue};
            --tab_border_selected: ${ansi.blue};

            --separator_hover: ${ansi.white};
            --highlight_color: ${ansi.blue};

            --palette_window:     ${ansi.bg};
            --palette_windowText: ${ansi.fg};

            --palette_base:          ${ansi.bg};
            --palette_alternateBase: ${ansi.black};

            --palette_text:       ${ansi.fg};
            --palette_brightText: ${ansi.bright_white};

            --palette_button:     ${ansi.black};
            --palette_buttonText: ${ansi.fg};

            --palette_light:  ${ansi.bright_black};
            --palette_mid:    ${ansi.black};
            --palette_dark:   ${ansi.bg};
            --palette_shadow: ${ansi.black};

            --palette_highlight:       ${ansi.blue};
            --palette_highlightedText: ${ansi.bg};

            --palette_link:        ${ansi.blue};
            --palette_linkVisited: ${ansi.magenta};

            --palette_text_active:   ${ansi.fg};
            --palette_text_disabled: ${ansi.bright_black};
            --palette_text_inactive: ${ansi.white};
        }

        QWidget {
            selection-background-color: ${ansi.blue};
        }

        VolumeMeter {
            qproperty-backgroundNominalColor: ${ansi.green};
            qproperty-backgroundWarningColor: ${ansi.yellow};
            qproperty-backgroundErrorColor:   ${ansi.red};
            qproperty-foregroundNominalColor: ${ansi.bright_green};
            qproperty-foregroundWarningColor: ${ansi.bright_yellow};
            qproperty-foregroundErrorColor:   ${ansi.bright_red};
            qproperty-majorTickColor:         ${ansi.fg};
            qproperty-minorTickColor:         ${ansi.bright_black};
        }
      '';
    }
  );
}
