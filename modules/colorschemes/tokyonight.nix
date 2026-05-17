{
  lib,
  variantNames,
  ...
}:
let
  targetDirectories = {
    aerc = "aerc";
    alacritty = "alacritty";
    btop = "btop";
    delta = "delta";
    dunst = "dunst";
    eza = "eza";
    fish = "fish";
    foot = "foot";
    fuzzel = "fuzzel";
    fzf = "fzf";
    gemini-cli = "gemini_cli";
    ghostty = "ghostty";
    gitui = "gitui";
    helix = "helix";
    kitty = "kitty";
    lazygit = "lazygit";
    opencode = "opencode";
    spotify-player = "spotify_player";
    tmux = "tmux";
    vesktop = "discord";
    wezterm = "wezterm";
    xfce4-terminal = "xfceterm";
    yazi = "yazi";
    zathura = "zathura";
    zellij = "zellij";
  };
in
{
  lightVariants = [ "day" ];

  targets =
    lib.mapAttrs (_: directory: {
      url = "github:folke/tokyonight.nvim";
      path = "extras/${directory}";
    }) targetDirectories
    // {
      spicetify = {
        url = "github:evening-hs/Spotify-Tokyo-Night-Theme";
        rev = "d88ca06eaeeb424d19e0d6f7f8e614e4bce962be";
        hash = "sha256-cLj9v8qtHsdV9FfzV2Qf4pWO8AOBXu51U/lUMvdEXAk=";
      };
    };

  options.style = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "moon";
    description = "The Tokyo Night style.";
  };

  variantFor = colorscheme: colorscheme.style;

  slugFor = _: variant: "tokyonight_${variant}";

  ansiFor = _: palette: {
    bg = palette.bg;
    fg = palette.fg;

    black = palette.black;
    red = palette.terminal_red;
    green = palette.terminal_green;
    yellow = palette.terminal_yellow;
    blue = palette.terminal_blue;
    magenta = palette.terminal_magenta;
    cyan = palette.terminal_cyan;
    white = palette.terminal_white;

    bright_black = palette.terminal_black_bright;
    bright_red = palette.terminal_red_bright;
    bright_green = palette.terminal_green_bright;
    bright_yellow = palette.terminal_yellow_bright;
    bright_blue = palette.terminal_blue_bright;
    bright_magenta = palette.terminal_magenta_bright;
    bright_cyan = palette.terminal_cyan_bright;
    bright_white = palette.terminal_white_bright;
  };
}
