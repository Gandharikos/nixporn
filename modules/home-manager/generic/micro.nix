{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "micro";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.micro.settings.colorscheme = "simple";
    }
  );
}
