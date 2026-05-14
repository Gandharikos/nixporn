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
  target = "vicinae";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."vicinae/themes/${slug}.toml".source = "${source}/extras/vicinae/${slug}.toml";
    programs.vicinae.settings.theme = {
      light.name = slug;
      dark.name = slug;
    };
  };
}
