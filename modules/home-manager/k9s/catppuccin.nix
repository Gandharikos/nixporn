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
  target = "k9s";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  enableXdgConfig = !pkgs.stdenv.hostPlatform.isDarwin || config.xdg.enable;
  transparent = cfg.${target}.transparent;
  themeName = "catppuccin-${flavor}" + lib.optionalString transparent "-transparent";
  themeFile = "${themeName}.yaml";
  themePath = "k9s/skins/${themeFile}";
  theme = "${sources.k9s}/dist/${themeFile}";
in
{
  config = lib.mkIf enable (
    lib.mkMerge [
      (lib.mkIf (!enableXdgConfig) {
        home.file."Library/Application Support/${themePath}".source = theme;
      })

      (lib.mkIf enableXdgConfig {
        xdg.configFile.${themePath}.source = theme;
      })

      {
        programs.k9s.settings.k9s.ui.skin = themeName;
      }
    ]
  );
}
