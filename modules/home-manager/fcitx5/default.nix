{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
in
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.fcitx5.apply = lib.mkOption {
    type = lib.types.bool;
    default = cfg.apply;
    defaultText = "config.nixporn.apply";
    description = ''
      Applies the theme by overwriting `$XDG_CONFIG_HOME/fcitx5/conf/classicui.conf`.
      If this is disabled, you must manually set the theme (e.g. by using `fcitx5-configtool`).
    '';
  };
}
