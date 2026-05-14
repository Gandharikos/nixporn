{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) kanagawa;
  inherit (kanagawa) variant;
  source = pkgs.nixporn.kanagawa;
  target = "alacritty";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.alacritty.settings.general.import = lib.mkBefore [
      "${source}/extras/alacritty/kanagawa_${variant}.toml"
    ];
  };
}
