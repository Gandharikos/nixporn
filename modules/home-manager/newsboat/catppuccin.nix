{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  sources = pkgs.nixporn.catppuccin;
  target = "newsboat";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  theme = if catppuccin.polarity == "light" then "latte" else "dark";
in
{
  config = lib.mkIf enable {
    programs.newsboat.extraConfig = lib.fileContents "${sources.newsboat}/${theme}";
  };
}
