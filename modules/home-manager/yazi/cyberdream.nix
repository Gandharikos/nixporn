{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) cyberdream;
  inherit (cyberdream) slug;
  source = pkgs.nixporn.cyberdream;
  target = "yazi";
  flavorName = lib.nixporn.yaziFlavorName slug;
  flavor = lib.nixporn.mkYaziFlavor pkgs slug "${source}/extras/yazi/${slug}.toml";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = lib.nixporn.yaziFlavorTheme slug;
    xdg.configFile."yazi/flavors/${flavorName}.yazi/flavor.toml".source = flavor;
  };
}
