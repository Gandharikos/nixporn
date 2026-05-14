{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "wezterm";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."wezterm/colors/dracula.toml".source = "${sources.wezterm}/dracula.toml";
    programs.wezterm.extraConfig = ''
      config.color_scheme = "Dracula (Official)"
    '';
  };
}
