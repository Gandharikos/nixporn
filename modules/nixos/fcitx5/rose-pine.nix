{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "fcitx5";
  fcitx5Enabled =
    (
      config.i18n.inputMethod ? enable
      && config.i18n.inputMethod.enable
      && config.i18n.inputMethod.type == "fcitx5"
    )
    || (config.i18n.inputMethod ? enabled && config.i18n.inputMethod.enabled == "fcitx5");
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable && fcitx5Enabled;
in
{
  config = lib.mkIf enable {
    i18n.inputMethod.fcitx5 = {
      addons = [ sources.fcitx5 ];
      settings.addons = lib.mkIf cfg.${target}.apply {
        classicui.globalSection.Theme = slug;
      };
    };
  };
}
