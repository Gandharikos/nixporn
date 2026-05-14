{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) kanagawa;
  inherit (kanagawa) variant;
  source = pkgs.nixporn.kanagawa;
  target = "kitty";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  themeFile =
    {
      dragon = "kanagawa_dragon.conf";
      lotus = "kanagawa_light.conf";
      wave = "kanagawa.conf";
    }
    .${variant};
in
{
  config = lib.mkIf enable {
    programs.kitty.extraConfig = lib.mkBefore ''
      include ${source}/extras/kitty/${themeFile}
    '';
  };
}
