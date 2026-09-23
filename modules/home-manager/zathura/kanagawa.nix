{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) variant;
  colors = import ../generic/kanagawa-colors.nix {
    inherit (cfg) palette;
    inherit variant;
  };
  target = "zathura";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
in
{
  # Ported from https://github.com/rebelot/kanagawa.nvim/pull/66.
  config = lib.mkIf enable {
    programs.zathura.extraConfig = ''
      set notification-error-bg "${colors.bg}"
      set notification-error-fg "${colors.invalid}"
      set notification-warning-bg "${colors.bg}"
      set notification-warning-fg "${colors.warning}"
      set notification-bg "${colors.bg}"
      set notification-fg "${colors.fg}"

      set completion-bg "${colors.bg}"
      set completion-fg "${colors.fgMuted}"
      set completion-group-bg "${colors.bgMuted}"
      set completion-group-fg "${colors.fgMuted}"
      set completion-highlight-bg "${colors.keyword}"
      set completion-highlight-fg "${colors.bg}"

      set index-bg "${colors.bg}"
      set index-fg "${colors.keyword}"
      set index-active-bg "${colors.keyword}"
      set index-active-fg "${colors.bg}"

      set inputbar-bg "${colors.bg}"
      set inputbar-fg "${colors.fgMuted}"
      set statusbar-bg "${colors.bg}"
      set statusbar-fg "${colors.fgMuted}"

      set highlight-color "${colors.attribute}"
      set highlight-active-color "${colors.invalid}"

      set default-bg "${colors.bg}"
      set default-fg "${colors.fgMuted}"
      set render-loading "true"
      set render-loading-bg "${colors.bg}"
      set render-loading-fg "${colors.fgMuted}"

      set recolor-lightcolor "${colors.bg}"
      set recolor-darkcolor "${colors.fgMuted}"
      set recolor "true"
    '';
  };
}
