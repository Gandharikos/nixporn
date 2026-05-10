{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."qt";
  enable = cfg.enable && targetCfg.enable && isLinux;
in
{
  config = mkIf enable {
    home.packages = [ pkgs.catppuccin-kvantum ];

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style = {
        name = "kvantum";
      };
    };
  };
}
