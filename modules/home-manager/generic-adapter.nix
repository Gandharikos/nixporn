{
  colorschemeName,
  target,
}:
{
  config,
  lib,
  pkgs,
  ...
}@moduleArgs:
let
  common = import ./common.nix { inherit colorschemeName; } moduleArgs;
  inherit (common)
    cfg
    colors
    hexToRgb
    hexToRgba
    isLight
    isLinux
    mkDefault
    mkIf
    rgba
    slug
    strip
    targetEnabled
    terminalPalette
    ;

  cssColors = with colors; ''
    @define-color bg ${bg};
    @define-color bg_dark ${bg_dark};
    @define-color bg_highlight ${bg_highlight};
    @define-color fg ${fg};
    @define-color fg_dark ${fg_dark};
    @define-color red ${red};
    @define-color green ${green};
    @define-color yellow ${yellow};
    @define-color blue ${blue};
    @define-color magenta ${magenta};
    @define-color cyan ${cyan};
    @define-color orange ${orange};
  '';

  cursorPalette = config.nixporn.colorscheme.palette;
  cursorColors =
    if cursorPalette ? cursor && builtins.isAttrs cursorPalette.cursor then
      cursorPalette.cursor
    else
      {
        baseColor = colors.blue;
        outlineColor = colors.bg_highlight;
        watchBackgroundColor = colors.orange;
      };
  cursorThemeName = "Bibata-${slug}";
  hyprcursorThemeName = "${cursorThemeName}-Hyprcursor";
  xcursorPackage = import ../../packages/bibata-xcursor.nix (
    {
      inherit (pkgs)
        clickgen
        fetchFromGitHub
        lib
        resvg
        stdenvNoCC
        ;
      inherit cursorThemeName;
    }
    // cursorColors
  );
  hyprcursorPackage = import ../../packages/bibata-hyprcursor.nix (
    {
      inherit (pkgs)
        fetchFromGitHub
        hyprcursor
        lib
        python3
        stdenvNoCC
        ;
      inherit (pkgs) python3Packages;
      cursorThemeName = hyprcursorThemeName;
    }
    // cursorColors
  );

  terminalCss = with colors; ''
    :root {
      --nixporn-bg: ${bg};
      --nixporn-bg-dark: ${bg_dark};
      --nixporn-bg-highlight: ${bg_highlight};
      --nixporn-fg: ${fg};
      --nixporn-fg-muted: ${fg_dark};
      --nixporn-red: ${red};
      --nixporn-green: ${green};
      --nixporn-yellow: ${yellow};
      --nixporn-blue: ${blue};
      --nixporn-magenta: ${magenta};
      --nixporn-cyan: ${cyan};
      --nixporn-orange: ${orange};
    }
  '';

  configs = {
    aerc.xdg.configFile."aerc/stylesets/${slug}".text = with colors; ''
      *.default=true
      *.normal=true
      default.fg=${fg}
      default.bg=${bg}
      title.fg=${blue}
      header.fg=${cyan}
      error.fg=${red}
      warning.fg=${yellow}
      success.fg=${green}
      selected.fg=${bg}
      selected.bg=${blue}
      marked.fg=${magenta}
      completion_pill.fg=${bg}
      completion_pill.bg=${magenta}
    '';

    alacritty.programs.alacritty.settings = mkIf (config.programs.alacritty.enable or false) {
      colors = with colors; {
        primary = {
          background = bg;
          foreground = fg;
        };
        cursor = {
          text = bg;
          cursor = blue;
        };
        selection = {
          text = fg;
          background = bg_visual;
        };
        normal = {
          inherit
            black
            red
            green
            yellow
            blue
            magenta
            cyan
            white
            ;
        };
        bright = {
          black = bright_black;
          red = bright_red;
          green = bright_green;
          yellow = bright_yellow;
          blue = bright_blue;
          magenta = bright_magenta;
          cyan = bright_cyan;
          white = bright_white;
        };
      };
    };

    "all-modules" = { };

    anki.xdg.configFile."nixporn/anki/${slug}.css".text = terminalCss;

    atuin.xdg.configFile."atuin/themes/${slug}.toml".text = with colors; ''
      [theme]
      name = "${slug}"
      background = "${bg}"
      foreground = "${fg}"
      primary = "${blue}"
      secondary = "${magenta}"
      success = "${green}"
      warning = "${yellow}"
      error = "${red}"
    '';

    bottom.xdg.configFile."bottom/themes/${slug}.toml".text = with colors; ''
      [colors]
      table_header_color = "${blue}"
      all_cpu_color = "${blue}"
      avg_cpu_color = "${magenta}"
      cpu_core_colors = ["${blue}", "${green}", "${yellow}", "${red}", "${magenta}", "${cyan}"]
      ram_color = "${green}"
      swap_color = "${yellow}"
      rx_color = "${cyan}"
      tx_color = "${magenta}"
      border_color = "${bg_highlight}"
      highlighted_border_color = "${blue}"
      text_color = "${fg}"
      selected_text_color = "${bg}"
      selected_bg_color = "${blue}"
    '';

    broot.xdg.configFile."broot/skins/${slug}.hjson".text = with colors; ''
      default: ${fg}
      tree: ${comment}
      file: ${fg}
      directory: ${blue}
      exe: ${green}
      link: ${cyan}
      pruning: ${fg_dark}
      perm__: ${fg_dark}
      perm_r: ${green}
      perm_w: ${yellow}
      perm_x: ${red}
      selected_line: ${bg_highlight}
      char_match: ${orange}
      file_error: ${red}
      flag_label: ${magenta}
      flag_value: ${cyan}
      input: ${fg}
      status_error: ${red}
      status_job: ${yellow}
      status_normal: ${fg}
    '';

    cava.programs.cava.settings = mkIf (config.programs.cava.enable or false) {
      color = with colors; {
        background = mkDefault bg;
        foreground = mkDefault blue;
        gradient = 1;
        gradient_color_1 = cyan;
        gradient_color_2 = blue;
        gradient_color_3 = magenta;
        gradient_color_4 = red;
      };
    };

    chrome.xdg.configFile."nixporn/chrome/${slug}.css".text = terminalCss;

    cursors = mkIf isLinux {
      home.pointerCursor = {
        name = cursorThemeName;
        package = xcursorPackage;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };
      home.packages = [ hyprcursorPackage ];
      home.sessionVariables = {
        XCURSOR_THEME = cursorThemeName;
        XCURSOR_SIZE = "24";
        HYPRCURSOR_THEME = hyprcursorThemeName;
        HYPRCURSOR_SIZE = "24";
      };
    };

    element-desktop.xdg.configFile."Element/themes/${slug}.json".text = builtins.toJSON {
      name = slug;
      is_dark = !isLight;
      colors = {
        accent = colors.blue;
        primary = colors.bg;
        secondary = colors.bg_dark;
        tertiary = colors.bg_highlight;
        text = colors.fg;
      };
    };

    firefox.xdg.configFile."nixporn/firefox/${slug}.css".text = terminalCss;

    foot.programs.foot.settings = mkIf (config.programs.foot.enable or false) {
      colors = with colors; {
        foreground = strip fg;
        background = strip bg;
        regular0 = strip black;
        regular1 = strip red;
        regular2 = strip green;
        regular3 = strip yellow;
        regular4 = strip blue;
        regular5 = strip magenta;
        regular6 = strip cyan;
        regular7 = strip white;
        bright0 = strip bright_black;
        bright1 = strip bright_red;
        bright2 = strip bright_green;
        bright3 = strip bright_yellow;
        bright4 = strip bright_blue;
        bright5 = strip bright_magenta;
        bright6 = strip bright_cyan;
        bright7 = strip bright_white;
        selection-foreground = strip fg;
        selection-background = strip bg_visual;
      };
    };

    freetube.xdg.configFile."FreeTube/nixporn-${slug}.css".text = terminalCss;

    fuzzel.programs.fuzzel.settings = mkIf (config.programs.fuzzel.enable or false) {
      colors = with colors; {
        background = "${strip bg}ff";
        text = "${strip fg}ff";
        match = "${strip blue}ff";
        selection = "${strip bg_highlight}ff";
        selection-text = "${strip fg}ff";
        selection-match = "${strip cyan}ff";
        border = "${strip blue}ff";
      };
    };

    gh-dash.xdg.configFile."gh-dash/themes/${slug}.yml".text = with colors; ''
      colors:
        text:
          primary: "${fg}"
          secondary: "${fg_dark}"
          inverted: "${bg}"
          faint: "${comment}"
        background:
          selected: "${bg_highlight}"
        border:
          primary: "${blue}"
          secondary: "${bg_highlight}"
          faint: "${bg_dark}"
        status:
          success: "${green}"
          warning: "${yellow}"
          fail: "${red}"
    '';

    gitui.xdg.configFile."gitui/theme-${slug}.ron".text = with colors; ''
      (
        selected_tab: Some("${blue}"),
        command_fg: Some("${fg}"),
        selection_bg: Some("${bg_highlight}"),
        selection_fg: Some("${fg}"),
        cmdbar_bg: Some("${bg_dark}"),
        cmdbar_extra_lines_bg: Some("${bg_dark}"),
        disabled_fg: Some("${comment}"),
        diff_line_add: Some("${green}"),
        diff_line_delete: Some("${red}"),
        diff_file_added: Some("${green}"),
        diff_file_removed: Some("${red}"),
        diff_file_moved: Some("${yellow}"),
        diff_file_modified: Some("${blue}"),
      )
    '';

    glamour.xdg.configFile."glamour/styles/${slug}.json".text = builtins.toJSON {
      document = {
        stylePrimitive = {
          color = colors.fg;
          backgroundColor = colors.bg;
        };
      };
      heading = {
        stylePrimitive.color = colors.blue;
      };
      link = {
        stylePrimitive.color = colors.cyan;
      };
      code = {
        stylePrimitive = {
          color = colors.green;
          backgroundColor = colors.bg_highlight;
        };
      };
      block_quote = {
        stylePrimitive.color = colors.comment;
      };
    };

    halloy.xdg.configFile."halloy/themes/${slug}.toml".text = with colors; ''
      [general]
      background = "${bg}"
      foreground = "${fg}"
      border = "${bg_highlight}"

      [buffer]
      action = "${magenta}"
      background = "${bg}"
      highlight = "${bg_highlight}"
      nick = "${blue}"
      text = "${fg}"

      [server_messages]
      join = "${green}"
      part = "${yellow}"
      quit = "${red}"
    '';

    helix.programs.helix = mkIf (config.programs.helix.enable or false) {
      settings.theme = mkDefault slug;
      themes.${slug} = with colors; {
        "ui.background" = {
          bg = "bg";
        };
        "ui.text" = "fg";
        "ui.selection" = {
          bg = "bg_visual";
        };
        "ui.cursor" = {
          fg = "bg";
          bg = "blue";
        };
        "ui.statusline" = {
          fg = "fg";
          bg = "bg_dark";
        };
        "comment" = "comment";
        "keyword" = "magenta";
        "string" = "green";
        "constant.numeric" = "orange";
        "function" = "blue";
        palette = {
          inherit
            bg
            fg
            red
            green
            yellow
            blue
            magenta
            cyan
            orange
            comment
            ;
          bg_dark = bg_dark;
          bg_visual = bg_visual;
        };
      };
    };

    hyprlock.programs.hyprlock.settings = mkIf (config.programs.hyprlock.enable or false) (
      with colors;
      {
        background = [
          {
            color = rgba bg 1.0;
          }
        ];
        input-field = [
          {
            font_color = rgba fg 1.0;
            inner_color = rgba bg_dark 0.85;
            outer_color = rgba blue 1.0;
            check_color = rgba yellow 1.0;
            fail_color = rgba red 1.0;
            placeholder_text = "<span foreground=\"${fg_dark}\">Password</span>";
          }
        ];
        label = [
          {
            color = rgba fg 1.0;
          }
        ];
      }
    );

    hyprtoolkit.xdg.configFile."hyprtoolkit/themes/${slug}.css".text = cssColors;

    imv.programs.imv.settings = mkIf (config.programs.imv.enable or false) {
      options = {
        background = strip colors.bg;
        overlay = true;
        overlay_text_color = strip colors.fg;
        overlay_background_color = strip colors.bg_dark;
      };
    };

    k9s.programs.k9s = mkIf (config.programs.k9s.enable or false) {
      settings.ui.skin = mkDefault slug;
      skins.${slug}.k9s = with colors; {
        body = {
          fgColor = fg;
          bgColor = bg;
          logoColor = blue;
        };
        prompt = {
          fgColor = fg;
          bgColor = bg_dark;
          suggestColor = cyan;
        };
        info = {
          fgColor = blue;
          sectionColor = magenta;
        };
        dialog = {
          fgColor = fg;
          bgColor = bg_dark;
          buttonFgColor = bg;
          buttonBgColor = blue;
          buttonFocusFgColor = bg;
          buttonFocusBgColor = magenta;
        };
      };
    };

    kvantum = mkIf isLinux {
      xdg.configFile."Kvantum/${slug}/${slug}.kvconfig".text = with colors; ''
        [%General]
        base.color=${bg}
        text.color=${fg}
        highlight.color=${blue}
        highlighted.text.color=${bg}
        window.color=${bg}
        button.color=${bg_highlight}
        view.color=${bg}
        visited.link.color=${magenta}
        link.color=${cyan}
        negative.text.color=${red}
        neutral.text.color=${yellow}
        positive.text.color=${green}
      '';
      xdg.configFile."Kvantum/${slug}/${slug}.svg".text = "";
    };

    lsd.xdg.configFile."lsd/colors.yaml".text = with colors; ''
      user: ${yellow}
      group: ${yellow}
      permission:
        read: ${green}
        write: ${yellow}
        exec: ${red}
        exec-sticky: ${magenta}
        no-access: ${comment}
      date:
        hour-old: ${green}
        day-old: ${yellow}
        older: ${red}
      size:
        none: ${comment}
        small: ${green}
        medium: ${yellow}
        large: ${red}
      inode:
        valid: ${cyan}
        invalid: ${comment}
      links:
        valid: ${cyan}
        invalid: ${comment}
      tree-edge: ${bg_highlight}
    '';

    mako.services.mako.settings = mkIf (config.services.mako.enable or false) (
      with colors;
      {
        background-color = mkDefault bg;
        text-color = mkDefault fg;
        border-color = mkDefault blue;
        progress-color = mkDefault "over ${bg_highlight}";
        "urgency=high" = {
          border-color = red;
        };
      }
    );

    mangohud.programs.mangohud.settings = mkIf (config.programs.mangohud.enable or false) {
      background_color = strip colors.bg;
      text_color = strip colors.fg;
      gpu_color = strip colors.green;
      cpu_color = strip colors.blue;
      vram_color = strip colors.magenta;
      ram_color = strip colors.yellow;
      engine_color = strip colors.cyan;
      frametime_color = strip colors.orange;
    };

    micro.xdg.configFile."micro/colorschemes/${slug}.micro".text = with colors; ''
      color-link default "${fg},${bg}"
      color-link comment "${comment}"
      color-link constant "${orange}"
      color-link identifier "${fg}"
      color-link statement "${magenta}"
      color-link symbol "${cyan}"
      color-link preproc "${yellow}"
      color-link type "${blue}"
      color-link special "${red}"
      color-link underlined "${cyan}"
      color-link error "${red}"
      color-link todo "${yellow},${bg_highlight}"
      color-link statusline "${fg},${bg_dark}"
      color-link tabbar "${fg},${bg_dark}"
      color-link current-line-number "${blue},${bg}"
    '';

    mpv.programs.mpv.config = mkIf (config.programs.mpv.enable or false) {
      osd-color = colors.fg;
      osd-border-color = colors.bg;
      osd-back-color = colors.bg_dark;
    };

    neovim = {
      xdg.configFile."nvim/colors/${slug}.lua".text = with colors; ''
        vim.cmd("highlight clear")
        vim.g.colors_name = "${slug}"
        vim.api.nvim_set_hl(0, "Normal", { fg = "${fg}", bg = "${bg}" })
        vim.api.nvim_set_hl(0, "Comment", { fg = "${comment}", italic = true })
        vim.api.nvim_set_hl(0, "String", { fg = "${green}" })
        vim.api.nvim_set_hl(0, "Function", { fg = "${blue}" })
        vim.api.nvim_set_hl(0, "Keyword", { fg = "${magenta}" })
        vim.api.nvim_set_hl(0, "Number", { fg = "${orange}" })
        vim.api.nvim_set_hl(0, "Visual", { bg = "${bg_visual}" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "${bg_highlight}" })
        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "${red}" })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "${yellow}" })
        vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "${cyan}" })
      '';
      programs.neovim.extraLuaConfig = mkIf (config.programs.neovim.enable or false) ''
        vim.cmd.colorscheme("${slug}")
      '';
    };

    newsboat.programs.newsboat.extraConfig = mkIf (config.programs.newsboat.enable or false) (
      with colors;
      ''
        color background          ${fg} ${bg}
        color listnormal         ${fg} ${bg}
        color listfocus          ${bg} ${blue} bold
        color listnormal_unread  ${cyan} ${bg}
        color listfocus_unread   ${bg} ${magenta} bold
        color info               ${fg} ${bg_dark}
        color article            ${fg} ${bg}
      ''
    );

    nushell.programs.nushell.extraConfig = mkIf (config.programs.nushell.enable or false) (
      with colors;
      ''
        $env.config.color_config = {
          separator: "${fg_dark}"
          leading_trailing_space_bg: "${bg_highlight}"
          header: "${blue}"
          date: "${magenta}"
          filesize: "${cyan}"
          row_index: "${yellow}"
          bool: "${orange}"
          int: "${orange}"
          duration: "${green}"
          range: "${yellow}"
          float: "${orange}"
          string: "${green}"
          nothing: "${comment}"
          binary: "${cyan}"
          cell-path: "${blue}"
          hints: "${comment}"
        }
      ''
    );

    obs.xdg.configFile."obs-studio/themes/${slug}.qss".text = cssColors;

    polybar.services.polybar.config = mkIf (config.services.polybar.enable or false) {
      "colors" = with colors; {
        background = bg;
        background-alt = bg_highlight;
        foreground = fg;
        primary = blue;
        secondary = magenta;
        alert = red;
        disabled = comment;
      };
    };

    qt5ct = mkIf isLinux {
      xdg.configFile."qt5ct/colors/${slug}.conf".text = with colors; ''
        [ColorScheme]
        active_colors=${fg}, ${bg}, ${bg_highlight}, ${bg_dark}, ${bg_highlight}, ${fg_dark}, ${fg}, ${fg}, ${fg}, ${bg}, ${bg}, ${bg}, ${blue}, ${bg}, ${blue}, ${red}, ${green}, ${black}, ${bg_dark}, ${fg}
        disabled_colors=${comment}, ${bg}, ${bg_highlight}, ${bg_dark}, ${bg_highlight}, ${comment}, ${comment}, ${comment}, ${comment}, ${bg}, ${bg}, ${bg}, ${bg_highlight}, ${bg}, ${bg_highlight}, ${red}, ${green}, ${black}, ${bg_dark}, ${comment}
        inactive_colors=${fg}, ${bg}, ${bg_highlight}, ${bg_dark}, ${bg_highlight}, ${fg_dark}, ${fg}, ${fg}, ${fg}, ${bg}, ${bg}, ${bg}, ${blue}, ${bg}, ${blue}, ${red}, ${green}, ${black}, ${bg_dark}, ${fg}
      '';
    };

    qutebrowser.programs.qutebrowser.extraConfig = mkIf (config.programs.qutebrowser.enable or false) (
      with colors;
      ''
        c.colors.completion.category.bg = "${bg_dark}"
        c.colors.completion.category.fg = "${blue}"
        c.colors.completion.even.bg = "${bg}"
        c.colors.completion.odd.bg = "${bg}"
        c.colors.completion.fg = "${fg}"
        c.colors.completion.item.selected.bg = "${bg_highlight}"
        c.colors.completion.item.selected.fg = "${fg}"
        c.colors.statusbar.normal.bg = "${bg_dark}"
        c.colors.statusbar.normal.fg = "${fg}"
        c.colors.tabs.bar.bg = "${bg_dark}"
        c.colors.tabs.selected.even.bg = "${bg}"
        c.colors.tabs.selected.even.fg = "${blue}"
        c.colors.tabs.selected.odd.bg = "${bg}"
        c.colors.tabs.selected.odd.fg = "${blue}"
        c.colors.webpage.darkmode.enabled = ${if isLight then "False" else "True"}
      ''
    );

    rio.xdg.configFile."rio/themes/${slug}.toml".text = with colors; ''
      [colors]
      background = "${bg}"
      foreground = "${fg}"
      cursor = "${blue}"
      selection-background = "${bg_visual}"
      selection-foreground = "${fg}"
      black = "${black}"
      red = "${red}"
      green = "${green}"
      yellow = "${yellow}"
      blue = "${blue}"
      magenta = "${magenta}"
      cyan = "${cyan}"
      white = "${white}"
      light-black = "${bright_black}"
      light-red = "${bright_red}"
      light-green = "${bright_green}"
      light-yellow = "${bright_yellow}"
      light-blue = "${bright_blue}"
      light-magenta = "${bright_magenta}"
      light-cyan = "${bright_cyan}"
      light-white = "${bright_white}"
    '';

    rofi.programs.rofi.theme = mkIf (config.programs.rofi.enable or false) (
      with colors;
      {
        "*" = {
          background = bg;
          background-alt = bg_highlight;
          foreground = fg;
          selected = blue;
          active = green;
          urgent = red;
        };
        window = {
          background-color = mkDefault "@background";
          text-color = mkDefault "@foreground";
        };
        "element selected" = {
          background-color = mkDefault "@selected";
          text-color = mkDefault bg;
        };
      }
    );

    skim.programs.skim.defaultOptions = mkIf (config.programs.skim.enable or false) (
      with colors;
      [
        "--color=bg:${bg},fg:${fg},hl:${blue},bg+:${bg_highlight},fg+:${fg},hl+:${cyan},info:${comment},prompt:${blue},pointer:${magenta},marker:${magenta},spinner:${magenta},header:${orange}"
      ]
    );

    sway.wayland.windowManager.sway.config = mkIf (config.wayland.windowManager.sway.enable or false) {
      colors = with colors; {
        focused = {
          border = blue;
          background = blue;
          text = bg;
          indicator = cyan;
          childBorder = blue;
        };
        focusedInactive = {
          border = bg_highlight;
          background = bg_highlight;
          text = fg;
          indicator = bg_highlight;
          childBorder = bg_highlight;
        };
        unfocused = {
          border = bg_dark;
          background = bg_dark;
          text = fg_dark;
          indicator = bg_dark;
          childBorder = bg_dark;
        };
        urgent = {
          border = red;
          background = red;
          text = bg;
          indicator = red;
          childBorder = red;
        };
      };
    };

    swaylock.programs.swaylock.settings = mkIf (config.programs.swaylock.enable or false) (
      with colors;
      {
        color = strip bg;
        inside-color = strip bg_dark;
        ring-color = strip blue;
        key-hl-color = strip green;
        bs-hl-color = strip red;
        text-color = strip fg;
        line-color = strip bg_highlight;
        separator-color = strip bg_highlight;
        inside-clear-color = strip yellow;
        ring-clear-color = strip yellow;
        inside-ver-color = strip blue;
        ring-ver-color = strip blue;
        inside-wrong-color = strip red;
        ring-wrong-color = strip red;
      }
    );

    swaync.xdg.configFile."swaync/style.css".text = cssColors + ''
      * {
        color: @fg;
      }
      .notification {
        background: @bg;
        border: 1px solid @bg_highlight;
      }
      .notification-row:focus,
      .notification-row:hover {
        background: @bg_highlight;
      }
      .control-center {
        background: @bg_dark;
      }
    '';

    thunderbird.xdg.configFile."nixporn/thunderbird/${slug}.css".text = terminalCss;

    tofi.xdg.configFile."tofi/themes/${slug}".text = with colors; ''
      background-color = ${bg}
      text-color = ${fg}
      selection-color = ${blue}
      selection-background = ${bg_highlight}
      border-color = ${blue}
      prompt-color = ${cyan}
    '';

    vesktop.xdg.configFile."vesktop/themes/${slug}.css".text = terminalCss;

    vicinae.xdg.configFile."vicinae/themes/${slug}.json".text = builtins.toJSON {
      name = slug;
      appearance = if isLight then "light" else "dark";
      colors = {
        background = colors.bg;
        foreground = colors.fg;
        primary = colors.blue;
        secondary = colors.magenta;
        border = colors.bg_highlight;
        muted = colors.comment;
      };
    };

    vivid.xdg.configFile."vivid/themes/${slug}.yml".text = with colors; ''
      colors:
        black: '${black}'
        red: '${red}'
        green: '${green}'
        yellow: '${yellow}'
        blue: '${blue}'
        magenta: '${magenta}'
        cyan: '${cyan}'
        white: '${white}'
        bright_black: '${bright_black}'
        bright_red: '${bright_red}'
        bright_green: '${bright_green}'
        bright_yellow: '${bright_yellow}'
        bright_blue: '${bright_blue}'
        bright_magenta: '${bright_magenta}'
        bright_cyan: '${bright_cyan}'
        bright_white: '${bright_white}'
    '';

    vscode.programs.vscode.userSettings = mkIf (config.programs.vscode.enable or false) {
      "workbench.colorCustomizations" = with colors; {
        "editor.background" = bg;
        "editor.foreground" = fg;
        "editorCursor.foreground" = blue;
        "editor.selectionBackground" = bg_visual;
        "sideBar.background" = bg_dark;
        "activityBar.background" = bg_dark;
        "statusBar.background" = bg_highlight;
        "statusBar.foreground" = fg;
        "terminal.foreground" = fg;
        "terminal.background" = bg;
        "terminal.ansiBlack" = black;
        "terminal.ansiRed" = red;
        "terminal.ansiGreen" = green;
        "terminal.ansiYellow" = yellow;
        "terminal.ansiBlue" = blue;
        "terminal.ansiMagenta" = magenta;
        "terminal.ansiCyan" = cyan;
        "terminal.ansiWhite" = white;
        "terminal.ansiBrightBlack" = bright_black;
        "terminal.ansiBrightRed" = bright_red;
        "terminal.ansiBrightGreen" = bright_green;
        "terminal.ansiBrightYellow" = bright_yellow;
        "terminal.ansiBrightBlue" = bright_blue;
        "terminal.ansiBrightMagenta" = bright_magenta;
        "terminal.ansiBrightCyan" = bright_cyan;
        "terminal.ansiBrightWhite" = bright_white;
      };
    };

    waybar.programs.waybar.style = mkIf (config.programs.waybar.enable or false) (
      cssColors
      + ''
        * {
          color: @fg;
        }
        window#waybar {
          background: @bg;
          border-bottom: 1px solid @bg_highlight;
        }
        #workspaces button.focused,
        #workspaces button.active {
          color: @bg;
          background: @blue;
        }
        #battery.warning {
          color: @yellow;
        }
        #battery.critical {
          color: @red;
        }
      ''
    );

    wleave.xdg.configFile."wleave/style.css".text = cssColors;

    wlogout.xdg.configFile."wlogout/style.css".text = cssColors + ''
      window {
        background: @bg;
      }
      button {
        color: @fg;
        background: @bg_dark;
        border: 1px solid @bg_highlight;
      }
      button:focus,
      button:hover {
        background: @blue;
        color: @bg;
      }
    '';

    xfce4-terminal.xdg.configFile."xfce4/terminal/terminalrc".text = with colors; ''
      [Configuration]
      ColorForeground=${fg}
      ColorBackground=${bg}
      ColorCursor=${blue}
      ColorSelection=${bg_visual}
      ColorSelectionUseDefault=FALSE
      ColorPalette=${black};${red};${green};${yellow};${blue};${magenta};${cyan};${white};${bright_black};${bright_red};${bright_green};${bright_yellow};${bright_blue};${bright_magenta};${bright_cyan};${bright_white}
    '';

    zed-editor.xdg.configFile."zed/themes/${slug}.json".text = builtins.toJSON {
      "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
      name = slug;
      author = "nixporn";
      themes = [
        {
          name = slug;
          appearance = if isLight then "light" else "dark";
          style = with colors; {
            background = bg;
            text = fg;
            "editor.background" = bg;
            "editor.foreground" = fg;
            "editor.active_line.background" = bg_highlight;
            "editor.selection.background" = bg_visual;
            "terminal.background" = bg;
            "terminal.foreground" = fg;
            "border" = bg_highlight;
            "border.focused" = blue;
          };
        }
      ];
    };

    zsh-syntax-highlighting.programs.zsh.syntaxHighlighting.styles =
      mkIf (config.programs.zsh.enable or false)
        {
          "default" = "fg=${strip colors.fg}";
          "unknown-token" = "fg=${strip colors.red}";
          "reserved-word" = "fg=${strip colors.magenta}";
          "alias" = "fg=${strip colors.cyan}";
          "suffix-alias" = "fg=${strip colors.cyan}";
          "builtin" = "fg=${strip colors.blue}";
          "function" = "fg=${strip colors.blue}";
          "command" = "fg=${strip colors.green}";
          "precommand" = "fg=${strip colors.yellow}";
          "commandseparator" = "fg=${strip colors.fg_dark}";
          "hashed-command" = "fg=${strip colors.green}";
          "path" = "fg=${strip colors.cyan},underline";
          "globbing" = "fg=${strip colors.orange}";
          "history-expansion" = "fg=${strip colors.magenta}";
          "single-hyphen-option" = "fg=${strip colors.yellow}";
          "double-hyphen-option" = "fg=${strip colors.yellow}";
          "single-quoted-argument" = "fg=${strip colors.green}";
          "double-quoted-argument" = "fg=${strip colors.green}";
          "dollar-quoted-argument" = "fg=${strip colors.green}";
          "redirection" = "fg=${strip colors.cyan}";
          "comment" = "fg=${strip colors.comment}";
        };
  };
in
{
  config = mkIf (targetEnabled target) (configs.${target} or { });
}
