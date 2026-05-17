{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "starship";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.starship.settings = {
      palette = "nixporn";
      palettes.nixporn = {
        inherit (ansi)
          black
          red
          green
          yellow
          blue
          cyan
          white
          ;
        purple = ansi.magenta;
        bright-black = ansi.bright_black;
        bright-red = ansi.bright_red;
        bright-green = ansi.bright_green;
        bright-yellow = ansi.bright_yellow;
        bright-blue = ansi.bright_blue;
        bright-purple = ansi.bright_magenta;
        bright-cyan = ansi.bright_cyan;
        bright-white = ansi.bright_white;
      };
    };
  };
}
