{
  lib,
  nixpornSources,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."eza";
  enable = cfg.enable && targetCfg.enable && (config.programs.eza.enable or false);
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf enable {
    home.sessionVariables.EZA_CONFIG_DIR = lib.mkDefault "${config.xdg.configHome}/eza";

    xdg.configFile."eza/theme.yml".source = "${src}/extras/eza/${slug}.yml";
  };
}
