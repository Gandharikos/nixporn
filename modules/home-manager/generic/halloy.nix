{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "halloy";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = "nixporn-${colorscheme}";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.halloy = {
        settings.theme = themeName;
        themes.${themeName} = {
          general = {
            background = ansi.bg;
            border = ansi.bright_white;
            horizontal_rule = ansi.black;
            unread_indicator = ansi.yellow;
          };
          text = {
            primary = ansi.fg;
            secondary = ansi.bright_black;
            tertiary = ansi.yellow;
            success = ansi.green;
            error = ansi.red;
          };
          buffer = {
            action = ansi.green;
            background = ansi.bg;
            background_text_input = ansi.black;
            background_title_bar = ansi.black;
            border = ansi.bright_black;
            border_selected = ansi.bright_white;
            code = ansi.magenta;
            highlight = ansi.black;
            nickname = ansi.cyan;
            selection = ansi.black;
            timestamp = ansi.fg;
            topic = ansi.bright_black;
            url = ansi.blue;
            server_messages = {
              join = ansi.green;
              part = ansi.red;
              quit = ansi.red;
              default = ansi.cyan;
            };
          };
        };
      };
    }
  );
}
