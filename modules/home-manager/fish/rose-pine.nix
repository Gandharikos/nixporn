{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) variant;
  sources = pkgs.nixporn.rose-pine;
  target = "fish";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  themeName = "Rosé Pine" + lib.optionalString (variant != "main") " ${lib.toSentenceCase variant}";
in
{
  config = lib.mkIf enable {
    xdg.configFile."fish/themes/${themeName}.theme".source =
      "${sources.fish}/themes/${themeName}.theme";
    programs.fish.shellInit = ''
      fish_config theme choose "${themeName}"
    '';
  };
}
