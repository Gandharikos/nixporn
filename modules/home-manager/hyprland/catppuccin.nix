{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "hyprland";
  cursorTarget = "cursors";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  cursorAccent = if cfg.${cursorTarget}.accent == "auto" then accent else cfg.${cursorTarget}.accent;
in
{
  config = lib.mkIf enable {
    home.sessionVariables = lib.mkIf cfg.${cursorTarget}.enable {
      HYPRCURSOR_SIZE = config.home.pointerCursor.size;
      HYPRCURSOR_THEME = "catppuccin-${flavor}-${cursorAccent}-cursors";
    };

    wayland.windowManager.hyprland.settings.source = [
      "${sources.hyprland}/${flavor}.conf"
      (pkgs.writeText "hyprland-catppuccin-${accent}.conf" ''
        $accent = ''$${accent}
        $accentAlpha = ''$${accent}Alpha
      '')
    ];
  };
}
