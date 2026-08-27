{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "spicetify";
  hasProgram = options.programs ? spicetify;
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;

  source = pkgs.nixporn.spicetify.dracula;
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.spicetify = {
        theme = {
          name = "Dracula";
          src = "${source}/Dracula";
        };
        colorScheme = "Base";
      };
    }
  );
}
