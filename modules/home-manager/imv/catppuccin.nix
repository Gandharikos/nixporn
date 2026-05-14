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
  target = "imv";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  importINI =
    path:
    lib.importJSON (
      pkgs.runCommand "catppuccin-imv-theme.json" { nativeBuildInputs = [ pkgs.jc ]; } ''
        jc --ini < ${path} > $out
      ''
    );
in
{
  config = lib.mkIf enable {
    programs.imv.settings = importINI "${sources.imv}/${flavor}.config";
  };
}
