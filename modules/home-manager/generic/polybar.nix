{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "polybar";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    services.polybar.extraConfig = ''
      [colors]
      background = ${ansi.bg}
      foreground = ${ansi.fg}
      background-alt = ${ansi.black}
      foreground-alt = ${ansi.bright_black}
      primary = ${ansi.blue}
      secondary = ${ansi.cyan}
      alert = ${ansi.red}
      disabled = ${ansi.bright_black}
    '';
  };
}
