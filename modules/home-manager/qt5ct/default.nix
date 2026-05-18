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

  options.nixporn.qt5ct.assertPlatformTheme = lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = false;
    description = ''
      Whether to assert that {option}`qt.platformTheme.name` is set to `"qtct"` when qtct themes are enabled.
    '';
  };

  config = lib.mkIf (cfg.enable && cfg.qt5ct.enable && config.qt.enable) {
    assertions = lib.mkIf cfg.qt5ct.assertPlatformTheme [
      {
        assertion = (config.qt.platformTheme.name or null) == "qtct";
        message = ''`qt.platformTheme.name` must be `"qtct"` to use `nixporn.qt5ct`.'';
      }
    ];
  };
}
