{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "vivid";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
in
{
  config = lib.mkIf enable {
    programs.vivid = {
      activeTheme = themeName;
      themes.${themeName} = {
        colors = {
          bg = ansi.bg;
          black = ansi.black;
          red = ansi.red;
          green = ansi.green;
          yellow = ansi.yellow;
          blue = ansi.blue;
          magenta = ansi.magenta;
          cyan = ansi.cyan;
          white = ansi.white;
          bright_black = ansi.bright_black;
          bright_red = ansi.bright_red;
          bright_green = ansi.bright_green;
          bright_yellow = ansi.bright_yellow;
          bright_blue = ansi.bright_blue;
          bright_magenta = ansi.bright_magenta;
          bright_cyan = ansi.bright_cyan;
          bright_white = ansi.bright_white;
          fg = ansi.fg;
        };
        core = {
          normal_text.foreground = "fg";
          regular_file.foreground = "fg";
          reset_to_normal = {
            background = "bg";
            foreground = "fg";
            font-style = "regular";
          };
          directory = {
            foreground = "blue";
            font-style = "bold";
          };
          symlink.foreground = "cyan";
          broken_symlink.foreground = "red";
          missing_symlink_target = {
            background = "red";
            foreground = "white";
            font-style = "bold";
          };
          executable_file = {
            foreground = "green";
            font-style = "bold";
          };
          socket = {
            foreground = "magenta";
            font-style = "bold";
          };
          tree_edge.foreground = "bright_black";
        };
        archives = {
          foreground = "yellow";
          font-style = "bold";
        };
        executable = {
          foreground = "green";
          font-style = "bold";
        };
        media.foreground = "magenta";
        office.foreground = "green";
        programming = {
          source.foreground = "blue";
          tooling.foreground = "cyan";
        };
        text.foreground = "fg";
        unimportant.foreground = "bright_black";
      };
    };
  };
}
