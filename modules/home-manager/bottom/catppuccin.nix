{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor slug;
  sources = pkgs.nixporn.catppuccin;
  target = "bottom";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.bottom.settings = lib.importTOML "${sources.bottom}/${flavor}.toml";
  };
}
