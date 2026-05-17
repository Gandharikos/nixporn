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
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = {
      "$scheme" = lib.mkDefault "https://yazi-rs.github.io/schemas/theme.json";
      flavor.use = lib.mkDefault slug;
    };
    xdg.configFile."yazi/flavors/${slug}.yazi/flavor.toml".source =
      "${source}/extras/yazi/${slug}.toml";
  };
}
