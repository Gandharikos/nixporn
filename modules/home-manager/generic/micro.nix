{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "micro";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
in
{
  config = lib.mkIf enable {
    programs.micro.settings.colorscheme = "simple";
  };
}
