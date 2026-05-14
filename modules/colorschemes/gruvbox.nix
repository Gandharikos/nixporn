{
  lib,
  name,
  variantNames,
  ...
}:
{
  lightVariants = [ "light" ];

  targets = {
    nvim = {
      url = "github:morhetz/gruvbox";
    };

    xfce4-terminal = {
      url = "github:morhetz/gruvbox-contrib";
      path = "xfce4-terminal";
    };

    xresources = {
      url = "github:morhetz/gruvbox-contrib";
      path = "xresources";
    };

    iterm2 = {
      url = "github:morhetz/gruvbox-contrib";
      path = "iterm2";
    };

    konsole = {
      url = "github:morhetz/gruvbox-contrib";
      path = "konsole";
    };

    mintty = {
      url = "github:morhetz/gruvbox-contrib";
      path = "mintty";
    };

    st = {
      url = "github:morhetz/gruvbox-contrib";
      path = "st";
    };
  };

  options.variant = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "dark";
    description = "The ${name} variant.";
  };

  variantFor = colorscheme: colorscheme.variant;

  slugFor = _: variant: "${name}-${variant}";

  ansiFor =
    variant: palette:
    if variant == "light" then
      {
        bg = palette.light0;
        fg = palette.dark1;
        black = palette.light0;
        red = palette.neutral_red;
        green = palette.neutral_green;
        yellow = palette.neutral_yellow;
        blue = palette.neutral_blue;
        magenta = palette.neutral_purple;
        cyan = palette.neutral_aqua;
        white = palette.dark1;
        bright_black = palette.gray_245;
        bright_red = palette.faded_red;
        bright_green = palette.faded_green;
        bright_yellow = palette.faded_yellow;
        bright_blue = palette.faded_blue;
        bright_magenta = palette.faded_purple;
        bright_cyan = palette.faded_aqua;
        bright_white = palette.dark0;
      }
    else
      {
        bg = palette.dark0;
        fg = palette.light1;
        black = palette.dark0;
        red = palette.neutral_red;
        green = palette.neutral_green;
        yellow = palette.neutral_yellow;
        blue = palette.neutral_blue;
        magenta = palette.neutral_purple;
        cyan = palette.neutral_aqua;
        white = palette.light1;
        bright_black = palette.gray_245;
        bright_red = palette.bright_red;
        bright_green = palette.bright_green;
        bright_yellow = palette.bright_yellow;
        bright_blue = palette.bright_blue;
        bright_magenta = palette.bright_purple;
        bright_cyan = palette.bright_aqua;
        bright_white = palette.light0;
      };
}
