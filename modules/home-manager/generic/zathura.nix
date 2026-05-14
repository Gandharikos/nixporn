{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "zathura";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.zathura.extraConfig = ''
        set default-bg "${ansi.bg}"
        set default-fg "${ansi.fg}"
        set statusbar-bg "${ansi.black}"
        set statusbar-fg "${ansi.fg}"
        set inputbar-bg "${ansi.bg}"
        set inputbar-fg "${ansi.fg}"
        set notification-bg "${ansi.bg}"
        set notification-fg "${ansi.fg}"
        set notification-error-bg "${ansi.red}"
        set notification-error-fg "${ansi.bg}"
        set notification-warning-bg "${ansi.yellow}"
        set notification-warning-fg "${ansi.bg}"
        set highlight-color "${ansi.yellow}"
        set highlight-active-color "${ansi.blue}"
        set completion-bg "${ansi.bg}"
        set completion-fg "${ansi.fg}"
        set completion-highlight-bg "${ansi.blue}"
        set completion-highlight-fg "${ansi.bg}"
        set recolor-lightcolor "${ansi.bg}"
        set recolor-darkcolor "${ansi.fg}"
      '';
    }
  );
}
