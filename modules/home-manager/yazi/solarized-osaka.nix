{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  source = pkgs.nixporn.solarized-osaka;
  target = "yazi";
  flavorName = lib.nixporn.yaziFlavorName slug;
  flavor = lib.nixporn.mkYaziFlavor pkgs slug "${source}/extras/yazi/${slug}.toml";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = lib.nixporn.yaziFlavorTheme slug;
    xdg.configFile."yazi/flavors/${flavorName}.yazi/flavor.toml".source = flavor;
  };
}
