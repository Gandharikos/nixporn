{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "btop";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
  themeFile = "${slug}.theme";
in
{
  config = lib.mkIf enable {
    xdg.configFile."btop/themes/${themeFile}".source = "${source}/extras/btop/${themeFile}";
    programs.btop.settings.color_theme = themeFile;
  };
}
