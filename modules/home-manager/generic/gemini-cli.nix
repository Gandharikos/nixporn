{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "gemini-cli";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = "nixporn-${colorscheme}";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.gemini-cli.settings = {
        theme = themeName;
        customThemes.${themeName} = {
          name = themeName;
          type = cfg.colorschemes.${colorscheme}.polarity;
          Background = ansi.bg;
          Foreground = ansi.fg;
          LightBlue = ansi.bright_blue;
          AccentBlue = ansi.blue;
          AccentPurple = ansi.magenta;
          AccentCyan = ansi.cyan;
          AccentGreen = ansi.green;
          AccentYellow = ansi.yellow;
          AccentRed = ansi.red;
          DiffAdded = ansi.green;
          DiffRemoved = ansi.red;
          Comment = ansi.bright_black;
          Gray = ansi.bright_black;
        };
      };
    }
  );
}
