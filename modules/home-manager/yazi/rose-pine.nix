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
    xdg.configFile."yazi/theme.toml".source = "${sources.yazi}/themes/${slug}.toml";
  };
}
