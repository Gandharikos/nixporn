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
  target = "fcitx5";
  fcitx5Enabled =
    (
      config.i18n.inputMethod ? enable
      && config.i18n.inputMethod.enable
      && config.i18n.inputMethod.type == "fcitx5"
    )
    || (config.i18n.inputMethod ? enabled && config.i18n.inputMethod.enabled == "fcitx5");
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable && fcitx5Enabled;
  themePackage = sources.fcitx5.override { inherit accent flavor; };
in
{
  config = lib.mkIf enable {
    i18n.inputMethod.fcitx5 = {
      addons = [ themePackage ];
      settings.addons = lib.mkIf cfg.${target}.apply {
        classicui.globalSection.Theme = "catppuccin-${flavor}-${accent}";
      };
    };
  };
}
