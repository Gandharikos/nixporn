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
    environment.systemPackages = [ pkgs.nordzy-cursor-theme ];
    environment.variables = {
      XCURSOR_THEME = "Nordzy-cursors${suffix}";
      HYPRCURSOR_THEME = "Nordzy-hyprcursors${suffix}";
    };
  };
}
