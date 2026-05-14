{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "helix";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = "nixporn-${colorscheme}";
  theme = pkgs.writeText "${themeName}.toml" ''
    "ui.background" = { bg = "bg" }
    "ui.text" = "fg"
    "ui.text.focus" = "bright_white"
    "ui.selection" = { bg = "black" }
    "ui.cursor" = { fg = "bg", bg = "fg" }
    "ui.cursor.match" = { fg = "yellow", modifiers = ["bold"] }
    "ui.cursorline.primary" = { bg = "black" }
    "ui.statusline" = { fg = "fg", bg = "black" }
    "ui.statusline.inactive" = { fg = "bright_black", bg = "black" }
    "ui.popup" = { fg = "fg", bg = "black" }
    "ui.window" = "bright_black"
    "ui.help" = { fg = "fg", bg = "black" }
    "ui.menu" = { fg = "fg", bg = "black" }
    "ui.menu.selected" = { fg = "bg", bg = "blue" }
    "comment" = "bright_black"
    "constant" = "cyan"
    "string" = "green"
    "variable" = "fg"
    "keyword" = "magenta"
    "function" = "blue"
    "type" = "yellow"
    "warning" = "yellow"
    "error" = "red"
    "info" = "blue"
    "hint" = "cyan"

    [palette]
    bg = "${ansi.bg}"
    fg = "${ansi.fg}"
    black = "${ansi.black}"
    red = "${ansi.red}"
    green = "${ansi.green}"
    yellow = "${ansi.yellow}"
    blue = "${ansi.blue}"
    magenta = "${ansi.magenta}"
    cyan = "${ansi.cyan}"
    white = "${ansi.white}"
    bright_black = "${ansi.bright_black}"
    bright_red = "${ansi.bright_red}"
    bright_green = "${ansi.bright_green}"
    bright_yellow = "${ansi.bright_yellow}"
    bright_blue = "${ansi.bright_blue}"
    bright_magenta = "${ansi.bright_magenta}"
    bright_cyan = "${ansi.bright_cyan}"
    bright_white = "${ansi.bright_white}"
  '';
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      xdg.configFile."helix/themes/${themeName}.toml".source = theme;
      programs.helix.settings = {
        theme = themeName;
        editor.color-modes = lib.mkDefault true;
      };
    }
  );
}
