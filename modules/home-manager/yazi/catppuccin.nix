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
  slug = "catppuccin-${flavor}-${accent}";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = {
      "$scheme" = lib.mkDefault "https://yazi-rs.github.io/schemas/theme.json";
      flavor.use = lib.mkDefault slug;
    };

    xdg.configFile = {
      "yazi/flavors/${slug}.yazi/flavor.toml".source = "${sources.yazi}/themes/${flavor}/${slug}.toml";
      "yazi/Catppuccin-${flavor}.tmTheme".source =
        "${sources.bat}/Catppuccin ${lib.toSentenceCase flavor}.tmTheme";
    };
  };
}
