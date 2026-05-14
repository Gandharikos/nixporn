{
  lib,
  name,
  variantNames,
  ...
}:
let
  targetDirectories = {
    alacritty = "alacritty";
    bat = "tmTheme";
    broot = "broot";
    fish = "fish";
    foot = "foot";
    ghostty = "ghostty";
    hyprland = "hyprland";
    kitty = "kitty";
    sway = "sway";
    wezterm = "wezterm";

    base16 = "base16";
    emacs = "emacs";
    gogh = "gogh";
    iterm2 = "iterm";
    mintty = "mintty";
    pywal = "pywal";
    textmate = "tmTheme";
    windows-terminal = "windows-terminal";
    xresources = "xresources";
  };
in
{
  lightVariants = [ "lotus" ];

  targets = lib.mapAttrs (_: directory: {
    url = "github:rebelot/kanagawa.nvim";
    path = "extras/${directory}";
  }) targetDirectories;

  options.variant = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "wave";
    description = "The ${name} variant.";
  };

  variantFor = colorscheme: colorscheme.variant;

  slugFor = _: variant: "${name}-${variant}";

  ansiFor =
    variant: palette:
    if variant == "dragon" then
      {
        bg = palette.dragonBlack3;
        fg = palette.dragonWhite;
        black = palette.dragonBlack0;
        red = palette.dragonRed;
        green = palette.dragonGreen2;
        yellow = palette.dragonYellow;
        blue = palette.dragonBlue2;
        magenta = palette.dragonPink;
        cyan = palette.dragonAqua;
        white = palette.dragonWhite;
        bright_black = palette.dragonGray;
        bright_red = palette.dragonRed;
        bright_green = palette.dragonGreen;
        bright_yellow = palette.dragonYellow;
        bright_blue = palette.dragonBlue;
        bright_magenta = palette.dragonViolet;
        bright_cyan = palette.dragonTeal;
        bright_white = palette.dragonWhite;
      }
    else if variant == "lotus" then
      {
        bg = palette.lotusWhite3;
        fg = palette.lotusInk1;
        black = palette.sumiInk3;
        red = palette.lotusRed;
        green = palette.lotusGreen;
        yellow = palette.lotusYellow;
        blue = palette.lotusBlue4;
        magenta = palette.lotusPink;
        cyan = palette.lotusAqua;
        white = palette.lotusInk1;
        bright_black = palette.lotusGray3;
        bright_red = palette.lotusRed2;
        bright_green = palette.lotusGreen2;
        bright_yellow = palette.lotusYellow2;
        bright_blue = palette.lotusTeal2;
        bright_magenta = palette.lotusViolet4;
        bright_cyan = palette.lotusAqua2;
        bright_white = palette.lotusInk2;
      }
    else
      {
        bg = palette.sumiInk3;
        fg = palette.fujiWhite;
        black = palette.sumiInk3;
        red = palette.autumnRed;
        green = palette.autumnGreen;
        yellow = palette.boatYellow2;
        blue = palette.crystalBlue;
        magenta = palette.oniViolet;
        cyan = palette.waveAqua1;
        white = palette.fujiWhite;
        bright_black = palette.sumiInk6;
        bright_red = palette.samuraiRed;
        bright_green = palette.springGreen;
        bright_yellow = palette.carpYellow;
        bright_blue = palette.springBlue;
        bright_magenta = palette.springViolet1;
        bright_cyan = palette.waveAqua2;
        bright_white = palette.oldWhite;
      };
}
