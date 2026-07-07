{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor palette;
  sources = pkgs.nixporn.catppuccin;
  target = "yazi";
  slug = "catppuccin-${flavor}-${accent}";
  flavorName = lib.nixporn.yaziFlavorName slug;
  flavorTomlBase = lib.nixporn.mkYaziFlavor pkgs slug "${sources.yazi}/themes/${flavor}/${slug}.toml";
  flavorToml =
    if cfg.transparent then
      pkgs.runCommand "yazi-${flavorName}-transparent-flavor.toml" { } ''
        substitute ${flavorTomlBase} $out \
          --replace 'overall = { bg = "${palette.base}" }' 'overall = { bg = "reset" }'
      ''
    else
      flavorTomlBase;
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = lib.nixporn.yaziFlavorTheme slug;

    xdg.configFile = {
      "yazi/flavors/${flavorName}.yazi/flavor.toml".source = flavorToml;
      "yazi/Catppuccin-${flavor}.tmTheme".source =
        "${sources.bat}/themes/Catppuccin ${lib.toSentenceCase flavor}.tmTheme";
    };
  };
}
