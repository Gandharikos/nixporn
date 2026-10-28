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
  flavorSource = "${sources.yazi}/flavors/${slug}.yazi";
  flavorWithIcons = pkgs.runCommand "yazi-${flavorName}-with-icons.toml" { } ''
    cat ${flavorSource}/flavor.toml > $out
    printf '\n' >> $out
    cat ${sources.yazi}/themes/${slug}.toml >> $out
  '';
  flavor = lib.nixporn.mkYaziFlavor pkgs slug flavorWithIcons;
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = lib.nixporn.yaziFlavorTheme slug;
    xdg.configFile = {
      "yazi/flavors/${flavorName}.yazi/flavor.toml".source = flavor;
      "yazi/flavors/${flavorName}.yazi/tmtheme.xml".source = "${flavorSource}/tmtheme.xml";
    };
  };
}
