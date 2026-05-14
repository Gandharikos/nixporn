{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "gemini-cli";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
  theme = lib.importJSON "${source}/extras/gemini_cli/${slug}.json";
in
{
  config = lib.mkIf enable {
    programs.gemini-cli.settings = {
      theme = theme.name;
      customThemes.${theme.name} = theme;
    };
  };
}
