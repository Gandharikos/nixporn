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
  target = "vscode";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions.catppuccin; [
        catppuccin-vsc
        catppuccin-vsc-icons
      ];
      userSettings = {
        "workbench.colorTheme" = "Catppuccin ${lib.toSentenceCase flavor}";
        "workbench.iconTheme" = "catppuccin-${flavor}";
        "catppuccin.accentColor" = accent;
        "editor.semanticHighlighting.enabled" = lib.mkDefault true;
        "terminal.integrated.minimumContrastRatio" = lib.mkDefault 1;
        "window.titleBarStyle" = lib.mkDefault "custom";
      };
    };
  };
}
