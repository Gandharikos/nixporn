{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  target = "spicetify";
  hasProgram = options.programs ? spicetify;
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;

  source = pkgs.nixporn.spicetify.catppuccin;
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.spicetify = {
        theme = {
          name = "catppuccin";
          src = "${source}/catppuccin";
          overwriteAssets = true;
        };
        colorScheme = flavor;
      };
    }
  );
}
