{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "yazi";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
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
