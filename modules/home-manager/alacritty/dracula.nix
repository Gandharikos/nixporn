{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "alacritty";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.alacritty.settings.general.import = lib.mkBefore [
      "${sources.alacritty}/dracula.toml"
    ];
  };
}
