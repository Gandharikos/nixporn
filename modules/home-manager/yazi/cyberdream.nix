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
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
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
