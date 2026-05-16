{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "imv";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.imv.settings.options = {
        background = hex ansi.bg;
        overlay_text_color = hex ansi.fg;
        overlay_background_color = hex ansi.black;
      };
    }
  );
}
