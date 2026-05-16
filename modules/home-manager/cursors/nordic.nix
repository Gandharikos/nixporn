{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "cursors";
  enable = cfg.enable && cfg.colorscheme == "nordic" && cfg.${target}.enable;
  suffix = if cfg.${target}.accent == "light" then "-white" else "";
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      name = "Nordzy-cursors${suffix}";
      package = pkgs.nordzy-cursor-theme;
    };

    home.packages = [ pkgs.nordzy-cursor-theme ];
    home.sessionVariables.HYPRCURSOR_THEME = "Nordzy-hyprcursors${suffix}";
  };
}
