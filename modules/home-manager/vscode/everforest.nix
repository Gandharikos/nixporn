{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) everforest;
  polarity = lib.toSentenceCase everforest.polarity;
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.vscode.enable;
in
{
  config = lib.mkIf enable {
    programs.vscode.profiles.default = {
      extensions = [ pkgs.nixporn.everforest.vscodeExtension ];
      userSettings = {
        "workbench.colorTheme" = "Everforest ${polarity}";
        "everforest.${everforest.polarity}Contrast" = everforest.contrast;
        "editor.semanticHighlighting.enabled" = lib.mkDefault true;
        "terminal.integrated.minimumContrastRatio" = lib.mkDefault 1;
        "window.titleBarStyle" = lib.mkDefault "custom";
      };
    };
  };
}
