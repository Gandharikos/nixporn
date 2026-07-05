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
  target = "starship";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeFile =
    if builtins.pathExists "${sources.starship}/themes/${flavor}.toml" then
      "${sources.starship}/themes/${flavor}.toml"
    else
      "${sources.starship}/${flavor}.toml";
in
{
  config = lib.mkIf enable {
    programs.starship.settings = (lib.importTOML themeFile) // {
      palette = "catppuccin_${flavor}";
    };
  };
}
