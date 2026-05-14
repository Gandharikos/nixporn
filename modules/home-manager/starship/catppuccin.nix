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
in
{
  config = lib.mkIf enable {
    programs.starship.settings = (lib.importTOML "${sources.starship}/${flavor}.toml") // {
      format = lib.mkDefault "$all";
      palette = "catppuccin_${flavor}";
    };
  };
}
