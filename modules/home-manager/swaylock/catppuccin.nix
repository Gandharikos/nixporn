{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "swaylock";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  importINI =
    path:
    lib.importJSON (
      pkgs.runCommand "catppuccin-swaylock-theme.json" { nativeBuildInputs = [ pkgs.jc ]; } ''
        jc --ini < ${path} > $out
      ''
    );
in
{
  config = lib.mkIf enable {
    programs.swaylock.settings = importINI "${sources.swaylock}/${flavor}.conf";
  };
}
