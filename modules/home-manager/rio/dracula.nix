{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "rio";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.rio.settings = lib.importTOML "${sources.rio}/dracula.toml";
  };
}
