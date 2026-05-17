{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "qutebrowser";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  background = ansi.bg;
  secondary-background = ansi.black;
  selection-background = ansi.bright_black;
  foreground = ansi.fg;
  inverted-foreground = ansi.bg;
  error = ansi.red;
  info = ansi.green;
  secondary-info = ansi.cyan;
  warning = ansi.magenta;
in
{
  config = lib.mkIf enable {
    programs.qutebrowser.settings = {
      colors.webpage.preferred_color_scheme = lib.mkIf (
        cfg.colorschemes.${colorscheme}.polarity == "dark"
      ) "dark";
      hints.border = "1px solid ${background}";
      colors = {
        completion = {
          category = {
            bg = background;
            fg = info;
            border = {
              bottom = background;
              top = background;
            };
          };
          even.bg = background;
          fg = foreground;
          item.selected = {
            bg = selection-background;
            border = {
              bottom = selection-background;
              top = selection-background;
            };
            fg = foreground;
            match.fg = info;
          };
          match.fg = info;
          odd.bg = secondary-background;
          scrollbar = {
            bg = background;
            fg = foreground;
          };
        };
        downloads = {
          bar.bg = background;
          error = {
            bg = error;
            fg = inverted-foreground;
          };
          start = {
            bg = info;
            fg = inverted-foreground;
          };
          stop = {
            bg = secondary-info;
            fg = inverted-foreground;
          };
        };
        hints = {
          bg = secondary-background;
          fg = foreground;
          match.fg = info;
        };
        keyhint = {
          bg = background;
          fg = foreground;
          suffix.fg = foreground;
        };
        messages = {
          error = {
            bg = error;
            fg = inverted-foreground;
            border = error;
          };
          info = {
            bg = info;
            fg = inverted-foreground;
            border = info;
          };
          warning = {
            bg = warning;
            fg = inverted-foreground;
            border = warning;
          };
        };
        prompts = {
          bg = background;
          border = "1px solid ${background}";
          fg = foreground;
          selected = {
            bg = secondary-background;
            fg = foreground;
          };
        };
        statusbar = {
          caret = {
            bg = selection-background;
            fg = foreground;
            selection = {
              bg = selection-background;
              fg = foreground;
            };
          };
          command = {
            bg = background;
            fg = foreground;
            private = {
              bg = secondary-background;
              fg = foreground;
            };
          };
          insert = {
            bg = info;
            fg = inverted-foreground;
          };
          normal = {
            bg = background;
            fg = foreground;
          };
          passthrough = {
            bg = secondary-info;
            fg = inverted-foreground;
          };
          private = {
            bg = secondary-background;
            fg = foreground;
          };
          progress.bg = info;
          url = {
            error.fg = error;
            fg = foreground;
            hover.fg = foreground;
            success = {
              http.fg = secondary-info;
              https.fg = info;
            };
            warn.fg = warning;
          };
        };
        tabs = {
          bar.bg = background;
          even = {
            bg = secondary-background;
            fg = foreground;
          };
          indicator = {
            inherit error;
            start = secondary-info;
            stop = info;
          };
          odd = {
            bg = background;
            fg = foreground;
          };
          selected = {
            even = {
              bg = selection-background;
              fg = foreground;
            };
            odd = {
              bg = selection-background;
              fg = foreground;
            };
          };
        };
        tooltip = {
          bg = background;
          fg = foreground;
        };
      };
    };
  };
}
