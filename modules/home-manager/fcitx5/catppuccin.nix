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
  target = "fcitx5";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themePackage = sources.fcitx5.override { inherit accent flavor; };
  themeName = "catppuccin-${flavor}-${accent}";
  classicUiFile = (pkgs.formats.iniWithGlobalSection { }).generate "fcitx5-classicui.conf" {
    globalSection.Theme = themeName;
  };
in
{
  config = lib.mkIf enable {
    xdg.configFile = lib.mkIf cfg.${target}.apply {
      "fcitx5/conf/classicui.conf".source = classicUiFile;
    };
    xdg.dataFile."fcitx5/themes/${themeName}".source =
      "${themePackage}/share/fcitx5/themes/${themeName}";
  };
}
