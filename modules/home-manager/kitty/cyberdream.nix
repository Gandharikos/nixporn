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
  target = "kitty";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.kitty.extraConfig = lib.mkBefore ''
      include ${source}/extras/kitty/${slug}.conf
    '';
  };
}
