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
  target = "btop";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  themeFile = "${slug}.theme";
in
{
  config = lib.mkIf enable {
    xdg.configFile."btop/themes/${themeFile}".source = "${sources.btop}/${themeFile}";
    programs.btop.settings.color_theme = slug;
  };
}
