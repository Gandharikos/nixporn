{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  source = pkgs.nixporn.solarized-osaka;
  target = "wezterm";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
  themeName =
    if solarized-osaka.variant == "light" then "Solarized Osaka Light" else "Solarized Osaka";
in
{
  config = lib.mkIf enable {
    xdg.configFile."wezterm/colors/${slug}.toml".source = "${source}/extras/wezterm/${slug}.toml";
    programs.wezterm.extraConfig = ''
      config.color_scheme = "${themeName}"
    '';
  };
}
