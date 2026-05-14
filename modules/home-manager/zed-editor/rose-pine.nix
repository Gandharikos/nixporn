{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) polarity slug variant;
  sources = pkgs.nixporn.rose-pine;
  target = "zed-editor";
  enable =
    cfg.enable
    && cfg.colorscheme == "rose-pine"
    && cfg.${target}.enable
    && config.programs.zed-editor.enable;
  themeName = "Rosé Pine" + lib.optionalString (variant != "main") " ${lib.toSentenceCase variant}";
in
{
  config = lib.mkIf enable {
    programs.zed-editor.userSettings.theme = {
      mode = polarity;
      light = themeName;
      dark = themeName;
    };

    xdg.configFile."zed/themes/rose-pine.json".source = "${sources.zed-editor}/themes/${slug}.json";
  };
}
