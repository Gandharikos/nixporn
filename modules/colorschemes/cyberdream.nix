{
  lib,
  name,
  variantNames,
  ...
}:
let
  targetDirectories = {
    alacritty = "alacritty";
    bat = "textmate";
    delta = "delta";
    fish = "fish";
    foot = "foot";
    ghostty = "ghostty";
    gitui = "gitui";
    helix = "helix";
    k9s = "k9s";
    kitty = "kitty";
    lazygit = "lazygit";
    lsd = "lsd";
    opencode = "opencode";
    rio = "rio";
    tmux = "tmux";
    vicinae = "vicinae";
    vivid = "vivid";
    wezterm = "wezterm";
    yazi = "yazi";
    zed-editor = "zed";
    zellij = "zellij";

    base16 = "base16";
    iterm2 = "iterm2";
    lazydocker = "lazydocker";
    posting = "posting";
    pywal = "pywal";
    superfile = "superfile";
    textmate = "textmate";
    tilix = "tilix";
    warp = "warp";
    windows-terminal = "windowsterminal";
  };
in
{
  lightVariants = [ "light" ];

  targets = lib.mapAttrs (_: directory: {
    url = "github:scottmckendry/cyberdream.nvim";
    path = "extras/${directory}";
  }) targetDirectories;

  options.variant = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "default";
    description = "The ${name} variant.";
  };

  variantFor = colorscheme: colorscheme.variant;

  slugFor = _: variant: if variant == "default" then name else "${name}-${variant}";

  ansiFor = _: palette: {
    inherit (palette)
      bg
      blue
      cyan
      fg
      green
      magenta
      red
      yellow
      ;

    black = palette.bg;
    bright_black = palette.grey;
    bright_blue = palette.blue;
    bright_cyan = palette.cyan;
    bright_green = palette.green;
    bright_magenta = palette.magenta;
    bright_red = palette.red;
    bright_white = palette.fg;
    bright_yellow = palette.yellow;
    white = palette.fg;
  };
}
