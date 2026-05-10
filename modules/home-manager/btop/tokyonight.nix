{
  lib,
  nixpornSources,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixporn.general) transparent;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."btop";
  enable = cfg.enable && targetCfg.enable && (config.programs.btop.enable or false);
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf enable {
    programs.btop.settings = {
      color_theme = slug;
      theme_background = transparent; # make it transparent
    };

    xdg.configFile."btop/themes/${slug}.theme".source = "${src}/extras/btop/${slug}.theme";
  };
}
