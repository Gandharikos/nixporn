{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "tofi";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.tofi.settings = {
        background-color = ansi.bg;
        text-color = ansi.fg;
        selection-color = ansi.blue;
        prompt-color = ansi.cyan;
        border-color = ansi.blue;
      };
    }
  );
}
