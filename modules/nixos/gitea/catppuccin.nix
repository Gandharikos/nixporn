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
  target = "gitea";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  supportedForges = [
    "gitea"
    "forgejo"
  ];
  builtinThemes = {
    gitea = [
      "auto"
      "gitea"
      "arc-greeen"
    ];
    forgejo = [
      "forgejo-auto"
      "forgejo-light"
      "forgejo-dark"
      "gitea-auto"
      "gitea-light"
      "gitea-dark"
      "forgejo-auto-deuteranopia-protanopia"
      "forgejo-light-deuteranopia-protanopia"
      "forgejo-dark-deuteranopia-protanopia"
      "forgejo-auto-tritanopia"
      "forgejo-light-tritanopia"
      "forgejo-dark-tritanopia"
    ];
  };
  flavors = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];
  accents = [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ];
  allThemes = lib.mapCartesianProduct ({ flavor, accent }: "catppuccin-${flavor}-${accent}") {
    flavor = flavors;
    accent = accents;
  };

  forgeConfig =
    forge:
    let
      service = config.services.${forge};
      hasAssetsDir = lib.versionAtLeast service.package.version "1.21.0";
      themeDir =
        if hasAssetsDir then
          "${service.customDir}/public/assets/css"
        else
          "${service.customDir}/public/css";
    in
    lib.mkIf (service.enable) {
      systemd.tmpfiles.settings."10-catppuccin-${forge}-theme" = {
        ${themeDir}."C+".argument = toString sources.gitea;
        "${service.customDir}/public".d = {
          inherit (service) user group;
        };
        "${service.customDir}/public/assets".d = lib.optionalAttrs hasAssetsDir {
          inherit (service) user group;
        };
      };

      services.${forge}.settings.ui = {
        DEFAULT_THEME = "catppuccin-${flavor}-${accent}";
        THEMES = lib.concatStringsSep "," (builtinThemes.${forge} ++ allThemes);
      };
    };
in
{
  config = lib.mkIf enable (lib.mkMerge (map forgeConfig supportedForges));
}
