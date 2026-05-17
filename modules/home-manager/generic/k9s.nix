{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "k9s";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
  bg = if cfg.${target}.transparent then "default" else ansi.bg;
in
{
  config = lib.mkIf enable {
    programs.k9s = {
      settings.k9s.ui.skin = themeName;
      skins.${themeName}.k9s = {
        body = {
          fgColor = ansi.fg;
          bgColor = bg;
          logoColor = ansi.cyan;
        };
        prompt = {
          fgColor = ansi.fg;
          bgColor = bg;
          suggestColor = ansi.bright_black;
        };
        info = {
          fgColor = ansi.green;
          sectionColor = ansi.fg;
        };
        dialog = {
          fgColor = ansi.fg;
          bgColor = ansi.black;
          buttonFgColor = ansi.fg;
          buttonBgColor = ansi.bright_black;
          buttonFocusFgColor = ansi.bg;
          buttonFocusBgColor = ansi.green;
          labelFgColor = ansi.yellow;
          fieldFgColor = ansi.fg;
        };
        frame = {
          border = {
            fgColor = ansi.bright_black;
            focusColor = ansi.black;
          };
          menu = {
            fgColor = ansi.fg;
            keyColor = ansi.green;
            numKeyColor = ansi.green;
          };
          crumbs = {
            fgColor = ansi.fg;
            bgColor = ansi.black;
            activeColor = ansi.bright_black;
          };
          status = {
            newColor = ansi.cyan;
            modifyColor = ansi.yellow;
            addColor = ansi.green;
            errorColor = ansi.red;
            highlightcolor = ansi.yellow;
            killColor = ansi.bright_black;
            completedColor = ansi.bright_black;
          };
          title = {
            fgColor = ansi.fg;
            bgColor = ansi.black;
            highlightColor = ansi.yellow;
            counterColor = ansi.cyan;
            filterColor = ansi.green;
          };
        };
        views = {
          table = {
            fgColor = ansi.fg;
            bgColor = bg;
            header = {
              fgColor = ansi.fg;
              bgColor = bg;
              sorterColor = ansi.red;
            };
          };
          yaml = {
            keyColor = ansi.red;
            colonColor = ansi.fg;
            valueColor = ansi.green;
          };
          logs = {
            fgColor = ansi.fg;
            bgColor = bg;
          };
        };
      };
    };
  };
}
