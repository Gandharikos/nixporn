{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "yazi";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = import ./yazi-theme.nix { inherit ansi; };
  };
}
