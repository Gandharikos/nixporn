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
  target = "zed-editor";
  targetCfg = cfg.${target};
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && targetCfg.enable
    && config.programs.zed-editor.enable;

  accentName = lib.optionalString (accent != "mauve") " (${accent})";
  flavorName = lib.toSentenceCase flavor;
  themeName = "Catppuccin ${flavorName}${accentName}${
    lib.optionalString (!targetCfg.italics) " - No Italics"
  }";
  themeFile = "catppuccin-${lib.optionalString (!targetCfg.italics) "no-italics-"}${accent}.json";
in
{
  config = lib.mkIf enable {
    programs.zed-editor = {
      extensions = lib.optionals targetCfg.icons.enable [ "catppuccin-icons" ];

      userSettings = {
        icon_theme = lib.mkIf targetCfg.icons.enable "Catppuccin ${lib.toSentenceCase targetCfg.icons.flavor}";
        theme = {
          mode = catppuccin.polarity;
          light = themeName;
          dark = themeName;
        };
      };
    };

    xdg.configFile."zed/themes/catppuccin.json".source = "${sources.zed}/themes/${themeFile}";
  };
}
