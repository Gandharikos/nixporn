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

  targets = lib.mapAttrs (_: directory: {
    url = "github:folke/tokyonight.nvim";
    path = "extras/${directory}";
  }) targetDirectories;

  options.style = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "moon";
    description = "The Tokyo Night style.";
  };

  variantFor = colorscheme: colorscheme.style;

  slugFor = _: variant: "tokyonight_${variant}";
}
