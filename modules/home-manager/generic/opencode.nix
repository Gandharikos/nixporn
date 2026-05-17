{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "opencode";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
  mkColor = color: {
    dark = color;
    light = color;
  };
in
{
  config = lib.mkIf enable {
    programs.opencode = {
      tui.theme = themeName;
      themes.${themeName}.theme = {
        accent = mkColor ansi.magenta;
        background = mkColor ansi.bg;
        backgroundElement = mkColor ansi.black;
        backgroundPanel = mkColor ansi.black;
        border = mkColor ansi.bright_black;
        borderActive = mkColor ansi.blue;
        borderSubtle = mkColor ansi.bright_black;
        diffAdded = mkColor ansi.green;
        diffAddedBg = mkColor ansi.black;
        diffAddedLineNumberBg = mkColor ansi.black;
        diffContext = mkColor ansi.bright_black;
        diffContextBg = mkColor ansi.black;
        diffHighlightAdded = mkColor ansi.green;
        diffHighlightRemoved = mkColor ansi.red;
        diffHunkHeader = mkColor ansi.bright_black;
        diffLineNumber = mkColor ansi.bright_black;
        diffRemoved = mkColor ansi.red;
        diffRemovedBg = mkColor ansi.black;
        diffRemovedLineNumberBg = mkColor ansi.black;
        error = mkColor ansi.red;
        info = mkColor ansi.cyan;
        markdownBlockQuote = mkColor ansi.bright_black;
        markdownCode = mkColor ansi.green;
        markdownCodeBlock = mkColor ansi.black;
        markdownEmph = mkColor ansi.yellow;
        markdownHeading = mkColor ansi.magenta;
        markdownHorizontalRule = mkColor ansi.bright_black;
        markdownImage = mkColor ansi.blue;
        markdownImageText = mkColor ansi.cyan;
        markdownLink = mkColor ansi.blue;
        markdownLinkText = mkColor ansi.cyan;
        markdownListEnumeration = mkColor ansi.cyan;
        markdownListItem = mkColor ansi.blue;
        markdownStrong = mkColor ansi.yellow;
        markdownText = mkColor ansi.fg;
        primary = mkColor ansi.blue;
        secondary = mkColor ansi.magenta;
        success = mkColor ansi.green;
        syntaxComment = mkColor ansi.bright_black;
        syntaxFunction = mkColor ansi.blue;
        syntaxKeyword = mkColor ansi.magenta;
        syntaxNumber = mkColor ansi.yellow;
        syntaxOperator = mkColor ansi.cyan;
        syntaxPunctuation = mkColor ansi.fg;
        syntaxString = mkColor ansi.green;
        syntaxType = mkColor ansi.yellow;
        syntaxVariable = mkColor ansi.bright_white;
        text = mkColor ansi.fg;
        textMuted = mkColor ansi.bright_black;
        warning = mkColor ansi.yellow;
      };
    };
  };
}
