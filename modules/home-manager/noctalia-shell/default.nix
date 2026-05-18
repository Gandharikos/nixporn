{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg) avatar wallpaper;
  target = "noctalia-shell";
  hasProgram = options.programs ? noctalia-shell;
  enable = cfg.enable && cfg.${target}.enable && (config.programs.noctalia-shell.enable or false);
in
{
  imports = lib.nixporn.scanPaths ./.;

  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.noctalia-shell.settings =
        lib.optionalAttrs (avatar != null) {
          general.avatarImage = toString avatar;
        }
        // lib.optionalAttrs (wallpaper != null) {
          wallpaper = {
            enabled = true;
            directory = builtins.dirOf (toString wallpaper);
          };
        };
    }
  );
}
