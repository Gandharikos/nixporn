{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "firefox";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themes = lib.importJSON "${sources.firefox}/themes.json";
in
{
  config = lib.mkIf enable {
    programs.firefox.profiles.default.extensions.settings."FirefoxColor@mozilla.com".settings = {
      firstRunDone = true;
      theme = themes.${flavor}.${accent};
    };
  };
}
