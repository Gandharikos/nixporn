{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  source = pkgs.nixporn.kanagawa;
  target = "fish";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fish.shellInit = lib.mkBefore ''
      source ${source}/extras/fish/kanagawa.fish
    '';
  };
}
