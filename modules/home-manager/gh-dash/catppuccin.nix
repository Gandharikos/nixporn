{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "gh-dash";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  importYAML =
    path:
    lib.importJSON (
      pkgs.runCommand "catppuccin-gh-dash-theme.json" { nativeBuildInputs = [ pkgs.yj ]; } ''
        yj < ${path} > $out
      ''
    );
in
{
  config = lib.mkIf enable {
    programs.gh-dash.settings.theme = importYAML "${sources.gh-dash}/themes/${flavor}/${accent}.yml";
  };
}
