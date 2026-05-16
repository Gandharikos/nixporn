{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "tmux";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.tmux.extraConfig = ''
        set -g status-position ${cfg.${target}.statusPosition}
        set -g status-style "fg=${ansi.fg},bg=${ansi.bg}"
        set -g message-style "fg=${ansi.fg},bg=${ansi.black}"
        set -g pane-border-style "fg=${ansi.black}"
        set -g pane-active-border-style "fg=${ansi.blue}"
        set -g window-status-current-style "fg=${ansi.bg},bg=${ansi.blue}"
        ${cfg.tmux.extraConfig}
      '';
    }
  );
}
