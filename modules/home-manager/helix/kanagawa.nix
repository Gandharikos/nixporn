{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) slug variant;
  colors = import ../generic/kanagawa-colors.nix {
    inherit (cfg) palette;
    inherit variant;
  };
  target = "helix";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  italic = color: {
    fg = color;
    modifiers = [ "italic" ];
  };
  bold = color: {
    fg = color;
    modifiers = [ "bold" ];
  };
  curl = color: {
    underline = {
      inherit color;
      style = "curl";
    };
  };
  background = {
    inherit (colors) fg;
  }
  // lib.optionalAttrs (!cfg.transparent) { inherit (colors) bg; };
  theme = {
    inherit (colors)
      attribute
      constant
      constructor
      error
      function
      hint
      info
      namespace
      operator
      punctuation
      rainbow
      special
      string
      type
      variable
      warning
      ;
    "type.builtin" = colors.type;
    "type.enum.variant" = colors.type;
    "constant.numeric" = colors.number;
    "constant.character" = colors.string;
    "constant.character.escape" = colors.escape;
    "string.regexp" = colors.escape;
    "string.special" = colors.special;
    "string.special.symbol" = colors.symbol;
    "string.special.url" = {
      fg = colors.special;
      underline = {
        color = colors.special;
        style = "curl";
      };
    };
    comment = italic colors.comment;
    "variable.parameter" = colors.parameter;
    "variable.builtin" = colors.builtin;
    "variable.other.member" = colors.member;
    label = colors.special;
    "punctuation.special" = colors.special;
    keyword = italic colors.keyword;
    "keyword.control.conditional" = italic colors.keyword;
    "keyword.control.import" = italic colors.keyword;
    "keyword.control.return" = italic colors.returnKeyword;
    "keyword.control.exception" = bold colors.returnKeyword;
    "keyword.function" = italic colors.keyword;
    "keyword.directive" = colors.directive;
    "keyword.directive.define" = colors.directive;
    "keyword.operator" = bold colors.operator;
    "function.macro" = colors.directive;
    tag = colors.function;
    "markup.heading" = colors.function;
    "markup.heading.1" = colors.function;
    "markup.heading.2" = colors.function;
    "markup.heading.3" = colors.function;
    "markup.heading.4" = colors.function;
    "markup.heading.5" = colors.function;
    "markup.heading.6" = colors.function;
    "markup.list" = colors.special;
    "markup.list.unchecked" = colors.gutter;
    "markup.list.checked" = colors.string;
    "markup.bold" = bold colors.builtin;
    "markup.italic" = italic colors.builtin;
    "markup.strikethrough".modifiers = [ "crossed_out" ];
    "markup.underline".modifiers = [ "underlined" ];
    "markup.link.url" = {
      fg = colors.special;
      underline = {
        color = colors.special;
        style = "curl";
      };
    };
    "markup.link.text" = colors.keyword;
    "markup.link.label" = colors.namespace;
    "markup.raw" = colors.string;
    "markup.quote" = colors.parameter;
    "diff.plus" = colors.diffAdded;
    "diff.minus" = colors.diffDeleted;
    "diff.delta" = colors.diffChanged;

    "ui.background" = background;
    "ui.linenr".fg = colors.gutter;
    "ui.linenr.selected".fg = colors.warning;
    "ui.statusline" = {
      fg = colors.fgMuted;
      bg = colors.bgDark;
    };
    "ui.statusline.inactive" = {
      fg = colors.gutter;
      bg = colors.bgDark;
    };
    "ui.statusline.normal" = {
      fg = colors.bg;
      bg = colors.modeNormal;
      modifiers = [ "bold" ];
    };
    "ui.statusline.insert" = {
      fg = colors.bg;
      bg = colors.modeInsert;
      modifiers = [ "bold" ];
    };
    "ui.statusline.select" = {
      fg = colors.bg;
      bg = colors.modeSelect;
      modifiers = [ "bold" ];
    };
    "ui.popup" = {
      fg = colors.fgMuted;
      bg = colors.bgDark;
    };
    "ui.window".fg = colors.bgDark;
    "ui.help" = {
      fg = colors.fgMuted;
      bg = colors.bgDark;
    };
    "ui.bufferline" = {
      fg = colors.fgMuted;
      bg = colors.bgDark;
    };
    "ui.bufferline.active" = {
      fg = colors.keyword;
      inherit (colors) bg;
      underline = {
        color = colors.keyword;
        style = "line";
      };
    };
    "ui.bufferline.background".bg = colors.bgDark;
    "ui.text" = colors.fg;
    "ui.text.focus" = {
      inherit (colors) fg;
      bg = colors.bgMuted;
      modifiers = [ "bold" ];
    };
    "ui.text.inactive".fg = colors.gutter;
    "ui.text.directory".fg = colors.function;
    "ui.virtual" = colors.gutter;
    "ui.virtual.ruler".bg = colors.bgMuted;
    "ui.virtual.indent-guide" = colors.bgMuted;
    "ui.virtual.inlay-hint" = {
      fg = colors.gutter;
      bg = colors.bgSubtle;
    };
    "ui.virtual.jump-label" = bold colors.builtin;
    "ui.selection".bg = colors.selection;
    "ui.cursor" = {
      fg = colors.bg;
      bg = colors.cursor;
    };
    "ui.cursor.primary" = {
      fg = colors.bg;
      bg = colors.fg;
    };
    "ui.cursor.match" = bold colors.warning;
    "ui.cursor.primary.normal" = {
      fg = colors.bg;
      bg = colors.fg;
    };
    "ui.cursor.primary.insert" = {
      fg = colors.bg;
      bg = colors.fg;
    };
    "ui.cursor.primary.select" = {
      fg = colors.bg;
      bg = colors.fg;
    };
    "ui.cursor.normal" = {
      fg = colors.bg;
      bg = colors.cursor;
    };
    "ui.cursor.insert" = {
      fg = colors.bg;
      bg = colors.cursor;
    };
    "ui.cursor.select" = {
      fg = colors.bg;
      bg = colors.cursor;
    };
    "ui.cursorline.primary".bg = colors.bgHighlight;
    "ui.highlight" = {
      bg = colors.bgMuted;
      modifiers = [ "bold" ];
    };
    "ui.menu" = {
      inherit (colors) fg;
      bg = colors.selection;
    };
    "ui.menu.selected" = {
      inherit (colors) fg;
      bg = colors.selectionStrong;
      modifiers = [ "bold" ];
    };
    "diagnostic.error" = curl colors.error;
    "diagnostic.warning" = curl colors.warning;
    "diagnostic.info" = curl colors.info;
    "diagnostic.hint" = curl colors.hint;
    "diagnostic.unnecessary".modifiers = [ "dim" ];
    "diagnostic.deprecated".modifiers = [ "crossed_out" ];
  };
  themeFile = (pkgs.formats.toml { }).generate "${slug}.toml" theme;
in
{
  # Ported from https://github.com/rebelot/kanagawa.nvim/pull/305.
  config = lib.mkIf enable {
    programs.helix.settings = {
      theme = slug;
      editor.color-modes = lib.mkDefault true;
    };
    xdg.configFile."helix/themes/${slug}.toml".source = themeFile;
  };
}
