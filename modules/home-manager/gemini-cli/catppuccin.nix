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
  target = "gemini-cli";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  theme = lib.importJSON "${sources.gemini-cli}/catppuccin-${flavor}.json";
in
{
  config = lib.mkIf enable {
    programs.gemini-cli.settings = {
      theme = theme.name;
      customThemes.${theme.name} = theme;
    };
  };
}
