{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "yazi";
  flavorName = lib.nixporn.yaziFlavorName slug;
  flavor = lib.nixporn.mkYaziFlavor pkgs slug "${sources.yazi}/themes/${slug}.toml";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = lib.nixporn.yaziFlavorTheme slug;
    xdg.configFile."yazi/flavors/${flavorName}.yazi/flavor.toml".source = flavor;
  };
}
