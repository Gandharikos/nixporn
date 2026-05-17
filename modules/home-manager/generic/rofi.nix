{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "rofi";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
  theme = pkgs.writeText "${themeName}.rasi" ''
    * {
      background: ${ansi.bg};
      background-alt: ${ansi.black};
      foreground: ${ansi.fg};
      selected: ${ansi.blue};
      active: ${ansi.green};
      urgent: ${ansi.red};
    }

    window {
      background-color: @background;
      text-color: @foreground;
      border: 2px;
      border-color: @selected;
    }

    mainbox, inputbar, listview, element {
      background-color: @background;
      text-color: @foreground;
    }

    element selected {
      background-color: @selected;
      text-color: @background;
    }
  '';
in
{
  config = lib.mkIf enable {
    programs.rofi.theme = theme;
  };
}
