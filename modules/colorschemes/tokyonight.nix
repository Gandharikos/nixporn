{
  lib,
  variantNames,
  ...
}:
let
  extraSources = builtins.fromJSON (builtins.readFile ../../pkgs/extra-sources.json);
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
        inherit (extraSources.tokyonight-spicetify) narHash rev url;
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
    inherit (palette)
      bg
      fg
      black
      ;

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
