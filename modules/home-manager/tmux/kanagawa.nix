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
        notice = palette.autumnYellow;
        error = palette.waveRed;
        muted = palette.sakuraPink;
        alert = palette.roninYellow;
      };
      dragon = {
        text = palette.dragonWhite;
        bgBar = palette.dragonBlack4;
        bgPane = palette.dragonBlack3;
        highlight = palette.dragonOrange;
        selection = palette.dragonBlack5;
        info = palette.dragonTeal;
        accent = palette.dragonAsh;
        notice = palette.dragonYellow;
        error = palette.dragonRed;
        muted = palette.dragonOrange;
        alert = palette.dragonYellow;
      };
      lotus = {
        text = palette.lotusInk1;
        bgBar = palette.lotusWhite2;
        bgPane = palette.lotusWhite3;
        highlight = palette.lotusRed4;
        selection = palette.lotusRed4;
        info = palette.lotusTeal1;
        accent = palette.lotusRed2;
        notice = palette.lotusAqua2;
        error = palette.lotusRed;
        muted = palette.lotusPink;
        alert = palette.lotusTeal3;
      };
    }
    .${variant};
  statusBackground = if cfg.transparent then "default" else colors.bgBar;
  leftPad = color: "#[fg=${color},bg=${statusBackground}]";
  rightPad = color: "#[fg=${color},bg=${statusBackground}]";
  statusComponent =
    color: icon: content:
    lib.concatStrings [
      (leftPad color)
      "#[fg=${colors.bgPane},bg=${color},bold] ${icon} "
      "#[fg=${colors.text},bg=${colors.highlight},nobold] ${content} "
      (rightPad colors.highlight)
    ];
  windowFlags = "#{?window_zoomed_flag,#[fg=${colors.accent}] 󰁌,}#{?window_activity_flag,#[fg=${colors.notice}] ,}#{?window_bell_flag,#[fg=${colors.error}] 󰂞,}";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.tmux.enable;
in
{
  config = lib.mkIf enable {
    programs.tmux.extraConfig = ''
      set -g status on
      set -g status-position ${cfg.tmux.statusPosition}
      set -g status-interval 5
      set -g status-justify left
      set -g status-left-length 50
      set -g status-right-length 150
      set -g status-style "fg=${colors.text},bg=${statusBackground}"
      setw -g window-status-separator " "
      setw -g window-status-activity-style none
      setw -g window-status-bell-style none

      set -g message-style "fg=${colors.text},bg=${colors.bgBar}"
      set -g message-command-style "fg=${colors.text},bg=${colors.bgBar}"
      set -g mode-style "fg=${colors.text},bg=${colors.selection},bold"
      set -g pane-border-style "fg=${colors.bgBar}"
      set -g pane-active-border-style "fg=${colors.accent}"

      set -g status-left "${leftPad colors.accent}#[fg=${colors.bgPane},bg=${colors.accent},bold] #{?client_prefix,#[fg=${colors.alert}]WAIT,#{?pane_in_mode,#[fg=${colors.info}]COPY,#{?pane_synchronized,#[fg=${colors.muted}]SYNC,#[fg=${colors.bgPane}]#S}}} ${rightPad colors.accent} "

      setw -g window-status-format "${leftPad colors.muted}#[fg=${colors.bgPane},bg=${colors.muted},bold] #I #[fg=${colors.text},bg=${colors.highlight},nobold] #W${windowFlags} ${rightPad colors.highlight}"
      setw -g window-status-current-format "${leftPad colors.accent}#[fg=${colors.bgPane},bg=${colors.accent},bold] #I #[fg=${colors.text},bg=${colors.selection},nobold] #W${windowFlags} ${rightPad colors.selection}"

      set -g status-right "${statusComponent colors.notice "" "#{pane_current_command}"}"
      set -ag status-right " ${statusComponent colors.accent "" "#S"}"
      set -ag status-right " ${statusComponent colors.info "󰃭" "%Y-%m-%d 󰅐 %H:%M"}"

      ${cfg.tmux.extraConfig}
    '';
  };
}
