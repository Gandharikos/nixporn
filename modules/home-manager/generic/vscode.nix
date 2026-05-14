{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "vscode";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.vscode.profiles.default.userSettings = {
        "editor.semanticHighlighting.enabled" = true;
        "terminal.integrated.minimumContrastRatio" = 1;
        "window.titleBarStyle" = "custom";
        "workbench.colorCustomizations" = {
          "activityBar.background" = ansi.bg;
          "activityBar.foreground" = ansi.fg;
          "activityBar.inactiveForeground" = ansi.bright_black;
          "editor.background" = ansi.bg;
          "editor.foreground" = ansi.fg;
          "editorCursor.foreground" = ansi.blue;
          "editorLineNumber.foreground" = ansi.bright_black;
          "editorLineNumber.activeForeground" = ansi.fg;
          "editor.selectionBackground" = ansi.black;
          "editorWidget.background" = ansi.black;
          "input.background" = ansi.black;
          "input.foreground" = ansi.fg;
          "list.activeSelectionBackground" = ansi.black;
          "list.activeSelectionForeground" = ansi.fg;
          "panel.background" = ansi.bg;
          "sideBar.background" = ansi.bg;
          "sideBar.foreground" = ansi.fg;
          "statusBar.background" = ansi.black;
          "statusBar.foreground" = ansi.fg;
          "terminal.ansiBlack" = ansi.black;
          "terminal.ansiRed" = ansi.red;
          "terminal.ansiGreen" = ansi.green;
          "terminal.ansiYellow" = ansi.yellow;
          "terminal.ansiBlue" = ansi.blue;
          "terminal.ansiMagenta" = ansi.magenta;
          "terminal.ansiCyan" = ansi.cyan;
          "terminal.ansiWhite" = ansi.white;
          "terminal.ansiBrightBlack" = ansi.bright_black;
          "terminal.ansiBrightRed" = ansi.bright_red;
          "terminal.ansiBrightGreen" = ansi.bright_green;
          "terminal.ansiBrightYellow" = ansi.bright_yellow;
          "terminal.ansiBrightBlue" = ansi.bright_blue;
          "terminal.ansiBrightMagenta" = ansi.bright_magenta;
          "terminal.ansiBrightCyan" = ansi.bright_cyan;
          "terminal.ansiBrightWhite" = ansi.bright_white;
        };
      };
    }
  );
}
