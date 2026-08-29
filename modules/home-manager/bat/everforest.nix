{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) everforest;
  target = "bat";
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.${target}.enable;
  useNativeTheme = everforest.contrast == "medium";
  nativeThemeName = "everforest-${everforest.mode}";
  generatedThemeName = everforest.slug;
  generated = import ../generic/bat-theme.nix {
    inherit pkgs;
    inherit (cfg.palette) ansi;
    themeName = generatedThemeName;
  };
in
{
  config = lib.mkIf enable {
    programs.bat = {
      config.theme = if useNativeTheme then nativeThemeName else generatedThemeName;
      themes =
        if useNativeTheme then
          {
            ${nativeThemeName} = {
              src = pkgs.nixporn.everforest.bat;
              file = "themes/${nativeThemeName}.tmTheme";
            };
          }
        else
          {
            ${generatedThemeName} = {
              src = generated.theme;
              file = generated.themeFile;
            };
          };
    };
  };
}
