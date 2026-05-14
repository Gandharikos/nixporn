{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "starship";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.starship.settings = (lib.importTOML "${sources.starship}/starship.theme.toml") // {
      format = lib.mkDefault "$all";
      palette = "dracula";
    };
  };
}
