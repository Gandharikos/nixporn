{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "vivid";
  inherit (cfg) colorscheme;
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
          inherit (ansi)
            bg
            black
            red
            green
            yellow
            blue
            magenta
            cyan
            white
            bright_black
            bright_red
            bright_green
            bright_yellow
            bright_blue
            bright_magenta
            bright_cyan
            bright_white
            fg
            ;
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
