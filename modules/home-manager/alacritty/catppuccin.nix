{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "alacritty";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.alacritty.settings.general.import = lib.mkBefore [
      "${sources.alacritty}/catppuccin-${flavor}.toml"
    ];
  };
}
