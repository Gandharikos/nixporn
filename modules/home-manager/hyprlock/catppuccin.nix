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
  target = "hyprlock";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.hyprlock.settings.source = [
      "${sources.hyprland}/${flavor}.conf"
      (pkgs.writeText "hyprlock-catppuccin-${accent}.conf" ''
        $accent = ''$${accent}
        $accentAlpha = ''$${accent}Alpha
      '')
      sources.hyprlock
    ];
  };
}
