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
  target = "yazi";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile = {
      "yazi/theme.toml".source = "${sources.yazi}/${flavor}/catppuccin-${flavor}-${accent}.toml";
      "yazi/Catppuccin-${flavor}.tmTheme".source =
        "${sources.bat}/Catppuccin ${lib.toSentenceCase flavor}.tmTheme";
    };
  };
}
