{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "gh-dash";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
  importYAML =
    path:
    lib.importJSON (
      pkgs.runCommand "dracula-gh-dash-theme.json" { nativeBuildInputs = [ pkgs.yj ]; } ''
        yj < ${path} > $out
      ''
    );
in
{
  config = lib.mkIf enable {
    programs.gh-dash.settings.theme = (importYAML "${sources.gh-dash}/config.yml").theme;
  };
}
