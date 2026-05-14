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
  target = "btop";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeFile = "catppuccin_${flavor}.theme";
in
{
  config = lib.mkIf enable {
    xdg.configFile."btop/themes/${themeFile}".source = "${sources.btop}/${themeFile}";
    programs.btop.settings.color_theme = themeFile;
  };
}
