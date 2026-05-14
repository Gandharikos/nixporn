{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "rofi";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.dataFile = {
      "rofi/themes/catppuccin-${flavor}.rasi".source =
        "${sources.rofi}/basic/.local/share/rofi/themes/catppuccin-${flavor}.rasi";
      "rofi/themes/catppuccin-default.rasi".source =
        "${sources.rofi}/basic/.local/share/rofi/themes/catppuccin-default.rasi";
    };
    programs.rofi.theme = {
      "@theme" = "catppuccin-default";
      "@import" = "catppuccin-${flavor}";
    };
  };
}
