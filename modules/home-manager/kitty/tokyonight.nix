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
  target = "kitty";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.kitty.extraConfig = lib.mkBefore ''
      include ${source}/extras/kitty/${slug}.conf
    '';
  };
}
