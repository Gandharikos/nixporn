{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) style;
  target = "spicetify";
  hasProgram = options.programs ? spicetify;
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;

  theme = pkgs.nixporn.spicetify.tokyonight;

  colorScheme =
    if style == "night" then
      "Night"
    else if style == "storm" then
      "Storm"
    else if style == "day" then
      "Light"
    else
      "Night";
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.spicetify = {
        theme = {
          name = "Tokyo";
          src = theme;
          overwriteAssets = true;
        };
        inherit colorScheme;
      };
    }
  );
}
