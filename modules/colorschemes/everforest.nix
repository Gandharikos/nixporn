{
  lib,
  name,
  ...
}:
{
  lightVariants = [
    "light-hard"
    "light-medium"
    "light-soft"
  ];

  targets = {
    bat = {
      url = "github:VasylRomanets/everforest-bat";
    };

    cursors = {
      url = "github:talwat/everforest-cursors";
    };

    ghostty = {
      url = "github:metalelf0/everforest.ghostty";
    };

    gtk = {
      url = "github:Fausto-Korpsvart/Everforest-GTK-Theme";
    };

    micro = {
      url = "github:atomashevic/everforest-micro";
    };

    nvim = {
      url = "github:sainnhe/everforest";
    };

    vscode = {
      url = "github:sainnhe/everforest-vscode";
    };

    yazi = {
      url = "github:Chromium-3-Oxide/everforest-medium.yazi";
    };
  };

  options = {
    mode = lib.mkOption {
      type = lib.types.enum [
        "dark"
        "light"
      ];
      default = "dark";
      description = "The ${name} light or dark mode.";
    };

    contrast = lib.mkOption {
      type = lib.types.enum [
        "hard"
        "medium"
        "soft"
      ];
      default = "medium";
      description = "The ${name} background contrast.";
    };
  };

  variantFor = colorscheme: "${colorscheme.mode}-${colorscheme.contrast}";

  slugFor = _: variant: "${name}-${variant}";

  ansiFor =
    variant: palette:
    let
      isLight = lib.hasPrefix "light-" variant;
    in
    {
      bg = palette.bg0;
      fg = palette.fg;
      black = if isLight then palette.fg else palette.bg3;
      red = palette.red;
      green = palette.green;
      yellow = palette.yellow;
      blue = palette.blue;
      magenta = palette.purple;
      cyan = palette.aqua;
      white = if isLight then palette.bg4 else palette.fg;
      bright_black = if isLight then palette.fg else palette.bg4;
      bright_red = palette.red;
      bright_green = palette.green;
      bright_yellow = palette.yellow;
      bright_blue = palette.blue;
      bright_magenta = palette.purple;
      bright_cyan = palette.aqua;
      bright_white = if isLight then palette.bg4 else palette.fg;
    };
}
