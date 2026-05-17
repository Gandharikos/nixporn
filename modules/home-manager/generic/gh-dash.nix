{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "gh-dash";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.gh-dash.settings.theme = {
      colors = {
        text = {
          primary = ansi.fg;
          secondary = ansi.blue;
          inverted = ansi.bg;
          faint = ansi.bright_black;
          warning = ansi.yellow;
          success = ansi.green;
          error = ansi.red;
        };
        background.selected = ansi.black;
        border = {
          primary = ansi.blue;
          secondary = ansi.bright_black;
          faint = ansi.black;
        };
      };
    };
  };
}
