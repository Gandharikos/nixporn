{ name, ... }:
{
  targets = {
    nvim = {
      url = "github:andersevenrud/nordic.nvim";
    };
  };

  variantFor = _: "default";

  slugFor = _: _: name;

  ansiFor = _: palette: {
    bg = palette.dark_black;
    fg = palette.white;

    inherit (palette)
      black
      blue
      bright_black
      bright_cyan
      bright_white
      cyan
      green
      red
      white
      yellow
      ;

    bright_blue = palette.intense_blue;
    bright_green = palette.green;
    bright_magenta = palette.purple;
    bright_red = palette.red;
    bright_yellow = palette.yellow;
    magenta = palette.purple;
  };
}
