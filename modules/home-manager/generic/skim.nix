{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "skim";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.skim.defaultOptions = [
      "--color=bg:${ansi.bg},bg+:${ansi.black},spinner:${ansi.yellow},hl:${ansi.blue}"
      "--color=fg:${ansi.fg},header:${ansi.blue},info:${ansi.cyan},pointer:${ansi.magenta}"
      "--color=marker:${ansi.green},fg+:${ansi.bright_white},prompt:${ansi.blue},hl+:${ansi.bright_blue}"
    ];
  };
}
