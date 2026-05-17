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
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = {
      "$scheme" = lib.mkDefault "https://yazi-rs.github.io/schemas/theme.json";
      flavor.use = lib.mkDefault slug;
    };
    xdg.configFile."yazi/flavors/${slug}.yazi/flavor.toml".source =
      "${sources.yazi}/themes/${slug}.toml";
  };
}
