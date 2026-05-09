{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}@moduleArgs:
let
  common = import ../common.nix { inherit colorschemeName; } moduleArgs;
  inherit (common)
    cfg
    colors
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
in
{
  config = mkIf (targetEnabled "tmux") {
    programs.tmux.extraConfig = mkIf (config.programs.tmux.enable or false) (
      with colors;
      ''
        set -g status-style bg=${if cfg.general.transparent then "default" else bg_statusline},fg=${fg}
        set -g message-style bg=${bg_highlight},fg=${blue}
        set -g message-command-style bg=${bg_highlight},fg=${blue}
        set -g mode-style bg=${bg_highlight},fg=${green}
        set -g pane-border-style fg=${fg_gutter}
        set -g pane-active-border-style fg=${blue}
        set -g status-left "#[fg=${blue}]#S"
        set -g status-right "#[fg=${cyan}]%Y-%m-%d %H:%M"
        setw -g window-status-current-style fg=${bg},bg=${blue},bold
        setw -g window-status-style fg=${fg},bg=${bg_highlight}
      ''
    );
  };
}
