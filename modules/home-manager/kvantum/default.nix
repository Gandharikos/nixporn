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

  options.nixporn.kvantum = {
    apply = lib.mkOption {
      type = lib.types.bool;
      default = cfg.apply;
      defaultText = "config.nixporn.apply";
      description = ''
        Applies the theme by overwriting `$XDG_CONFIG_HOME/Kvantum/kvantum.kvconfig`.
        If this is disabled, you must manually set the theme (e.g. by using `kvantummanager`).
      '';
    };

    assertStyle = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to assert that {option}`qt.style.name` is set to `"kvantum"` when Kvantum themes are enabled.
      '';
    };
  };

  config = lib.mkIf (cfg.enable && cfg.kvantum.enable && config.qt.enable) {
    assertions = lib.mkIf cfg.kvantum.assertStyle [
      {
        assertion = lib.elem (config.qt.style.name or null) [
          "kvantum"
          "Kvantum"
        ];
        message = ''`qt.style.name` must be `"kvantum"` to use `nixporn.kvantum`.'';
      }
    ];
  };
}
