{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "freetube";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  polarity = cfg.colorschemes.${colorscheme}.polarity;
  isLight = polarity == "light";

  baseTheme =
    if colorscheme == "dracula" then
      "dracula"
    else if colorscheme == "gruvbox" then
      "gruvbox${if isLight then "Light" else "Dark"}"
    else if colorscheme == "nordic" then
      "nordic"
    else if colorscheme == "solarized-osaka" then
      "solarized${if isLight then "Light" else "Dark"}"
    else if isLight then
      "light"
    else
      "dark";

  mainColor =
    if colorscheme == "dracula" then
      "DraculaPurple"
    else if colorscheme == "gruvbox" then
      "Gruvbox${if isLight then "Light" else "Dark"}Blue"
    else if colorscheme == "solarized-osaka" then
      "SolarizedBlue"
    else
      "Blue";

  secColor =
    if colorscheme == "dracula" then
      "DraculaPink"
    else if colorscheme == "gruvbox" then
      "Gruvbox${if isLight then "Light" else "Dark"}Purple"
    else if colorscheme == "solarized-osaka" then
      "SolarizedCyan"
    else
      "Cyan";
in
{
  config = lib.mkIf enable {
    programs.freetube.settings = {
      inherit
        baseTheme
        mainColor
        secColor
        ;
    };
  };
}
