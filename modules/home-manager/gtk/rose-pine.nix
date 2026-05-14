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
  target = "gtk";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    gtk = {
      theme = {
        name = "${slug}-gtk";
        package = sources.gtk;
      };

      iconTheme = {
        name = "${slug}-icons";
        package = sources.gtk;
      };
    };
  };
}
