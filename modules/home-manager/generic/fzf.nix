{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "fzf";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.fzf.colors = {
      bg = ansi.bg;
      "bg+" = ansi.black;
      fg = ansi.fg;
      "fg+" = ansi.bright_white;
      header = ansi.yellow;
      hl = ansi.blue;
      "hl+" = ansi.bright_blue;
      info = ansi.cyan;
      marker = ansi.green;
      pointer = ansi.magenta;
      prompt = ansi.blue;
      spinner = ansi.yellow;
    };
  };
}
