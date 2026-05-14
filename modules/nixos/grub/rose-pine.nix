{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.rose-pine;
  target = "grub";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    boot.loader.grub = {
      font = "${sources.grub}/DejaVuSans12.pf2";
      theme = sources.grub;
    };
  };
}
