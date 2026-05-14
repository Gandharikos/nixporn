{
  lib,
  name,
  variantNames,
  ...
}:
let
  targetDirectories = {
    aerc = "aerc";
    alacritty = "alacritty";
    delta = "delta";
    dunst = "dunst";
    fish = "fish_themes";
    foot = "foot";
    fuzzel = "fuzzel";
    fzf = "fzf";
    ghostty = "ghostty";
    gitui = "gitui";
    helix = "helix";
    kitty = "kitty";
    lazygit = "lazygit";
    spotify-player = "spotify_player";
    tmux = "tmux";
    vesktop = "discord";
    wezterm = "wezterm";
    xfce4-terminal = "xfceterm";
    yazi = "yazi";
    zathura = "zathura";
    zellij = "zellij";

    discord = "discord";
    gnome-terminal = "gnome_terminal";
    lua = "lua";
    prism = "prism";
    process-compose = "process_compose";
    slack = "slack";
    sublime = "sublime";
    terminator = "terminator";
    termux = "termux";
    tilix = "tilix";
    vimium = "vimium";
    windows-terminal = "windows_terminal";
    xresources = "xresources";
  };
in
{
  lightVariants = [ "light" ];

  targets = lib.mapAttrs (_: directory: {
    url = "github:craftzdog/solarized-osaka.nvim";
    path = "extras/${directory}";
  }) targetDirectories;

  options.variant = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "dark";
    description = "The ${name} variant.";
  };

  variantFor = colorscheme: colorscheme.variant;

  slugFor = _: variant: "solarized_osaka_${variant}";
}
