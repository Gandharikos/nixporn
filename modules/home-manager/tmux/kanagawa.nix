{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) variant;
  inherit (cfg) palette;
  colors =
    {
      wave = {
        text = palette.fujiWhite;
        bgBar = palette.sumiInk4;
        bgPane = palette.sumiInk3;
        highlight = palette.sumiInk5;
        selection = palette.sumiInk6;
        info = palette.waveAqua1;
        accent = palette.springViolet1;
        muted = palette.sakuraPink;
        alert = palette.roninYellow;
      };
      dragon = {
        text = palette.oldWhite;
        bgBar = palette.dragonBlack4;
        bgPane = palette.dragonBlack2;
        highlight = palette.dragonOrange;
        selection = palette.dragonBlack5;
        info = palette.dragonTeal;
        accent = palette.dragonAsh;
        muted = palette.dragonOrange;
        alert = palette.dragonYellow;
      };
      lotus = {
        text = palette.lotusInk1;
        bgBar = palette.lotusYellow2;
        bgPane = palette.lotusWhite3;
        highlight = palette.lotusRed4;
        selection = palette.lotusRed4;
        info = palette.lotusCyan;
        accent = palette.lotusRed2;
        muted = palette.lotusPink;
        alert = palette.lotusTeal3;
      };
    }
    .${variant};
  statusBackground = if cfg.transparent then "default" else colors.bgBar;
  currentWindowLeft =
    if cfg.transparent then
      "#[fg=${colors.selection},bg=default]"
    else
      "#[fg=${colors.bgBar},bg=${colors.selection}]";
  statusComponent =
    previousColor: color: icon: content:
    lib.concatStrings [
      "#[fg=${color},bg=${previousColor},nobold,nounderscore,noitalics]"
      "#[fg=${colors.bgPane},bg=${color}] ${icon} ${content} "
    ];
  inactiveWindowFlags = "#{?window_flags,#[fg=${colors.selection}]#{window_flags},}";
  currentWindowFlags = "#{?window_flags,#[fg=${colors.highlight}]#{window_flags},}";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.tmux.enable;
in
{
  config = lib.mkIf enable {
    programs.tmux.extraConfig = ''
      set -g status on
      set -g status-position ${cfg.tmux.statusPosition}
      set -g status-interval 5
      set -g status-justify left
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-style "fg=${colors.text},bg=${statusBackground}"
      setw -g window-status-separator ""
      setw -g window-status-activity-style bold
      setw -g window-status-bell-style bold

      set -g message-style "fg=${colors.text},bg=${colors.bgBar}"
      set -g message-command-style "fg=${colors.text},bg=${colors.bgBar}"
      set -g mode-style "fg=${colors.text},bg=${colors.selection},bold"
      set -g pane-border-style "fg=${colors.bgBar}"
      set -g pane-active-border-style "fg=${colors.selection}"
      ${lib.optionalString (!cfg.transparent) ''
        setw -g window-style "fg=${colors.text},bg=${colors.bgPane}"
      ''}

      set -g status-left "#{?client_prefix,#[fg=${colors.bgPane}]#[bg=${colors.alert}],#[fg=${colors.bgPane}]#[bg=${colors.accent}]} #{?client_prefix, WAIT,#{?pane_in_mode, COPY,#{?pane_synchronized, SYNC, #S}}} #{?client_prefix,#[fg=${colors.alert}],#[fg=${colors.accent}]}#[bg=${statusBackground}]"

      setw -g window-status-format "#[fg=${colors.text},bg=${statusBackground}] #I #W${inactiveWindowFlags}"
      setw -g window-status-current-format "${currentWindowLeft}#[fg=${colors.text},bg=${colors.selection}] #I #W${currentWindowFlags} #[fg=${colors.selection},bg=${statusBackground}]"

      set -g status-right "${statusComponent statusBackground colors.muted "" "#{pane_current_command}"}"
      set -ag status-right "${statusComponent colors.muted colors.info "󰃰" "%Y-%m-%d %H:%M"}"

      ${cfg.tmux.extraConfig}
    '';
  };
}
