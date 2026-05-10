{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources."solarized-osaka";
  cfg = config.nixporn."solarized-osaka";
  targetCfg = config.nixporn.targets."wezterm";
  schemeName = if cfg.variant == "light" then "Solarized Osaka Light" else "Solarized Osaka";
  enable = cfg.enable && targetCfg.enable && (config.programs.wezterm.enable or false);
in
{
  config = mkIf enable {
    programs.wezterm.extraConfig = ''
      config.color_scheme_dirs = { "${src}/extras/wezterm" }
      config.color_scheme = "${schemeName}"
    '';
  };
}
