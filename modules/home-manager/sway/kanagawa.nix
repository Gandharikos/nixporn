{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  source = pkgs.nixporn.kanagawa;
  target = "sway";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    wayland.windowManager.sway.extraConfigEarly = ''
      include ${source}/extras/sway/kanagawa.sway
    '';
  };
}
