{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "tofi";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.tofi.settings = {
      background-color = ansi.bg;
      text-color = ansi.fg;
      selection-color = ansi.blue;
      prompt-color = ansi.cyan;
      border-color = ansi.blue;
    };
  };
}
