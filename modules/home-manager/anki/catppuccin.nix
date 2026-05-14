{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  target = "anki";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.anki.addons = with pkgs.ankiAddons; [
      (recolor.withConfig {
        config =
          let
            inherit (catppuccin) polarity;
            flavor = lib.toSentenceCase catppuccin.flavor;
            version = builtins.splitVersion recolor.version;
          in
          (lib.importJSON "${recolor}/share/anki/addons/recolor/themes/(${polarity}) Catppuccin ${flavor}.json")
          // {
            version = {
              major = lib.toInt (builtins.elemAt version 0);
              minor = lib.toInt (builtins.elemAt version 1);
            };
          };
      })
    ];
  };
}
