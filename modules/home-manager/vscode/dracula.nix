{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "vscode";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.vscode.profiles.default = {
      extensions = [ pkgs.vscode-extensions.dracula-theme.theme-dracula ];
      userSettings = {
        "workbench.colorTheme" = "Dracula Theme";
        "editor.semanticHighlighting.enabled" = lib.mkDefault true;
        "terminal.integrated.minimumContrastRatio" = lib.mkDefault 1;
        "window.titleBarStyle" = lib.mkDefault "custom";
      };
    };
  };
}
