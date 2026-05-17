{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "fcitx5";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  classicUiFile = (pkgs.formats.iniWithGlobalSection { }).generate "fcitx5-classicui.conf" {
    globalSection.Theme = slug;
  };
in
{
  config = lib.mkIf enable {
    xdg.configFile = lib.mkIf cfg.${target}.apply {
      "fcitx5/conf/classicui.conf".source = classicUiFile;
    };
    xdg.dataFile."fcitx5/themes/${slug}".source = "${sources.fcitx5}/share/fcitx5/themes/${slug}";
  };
}
