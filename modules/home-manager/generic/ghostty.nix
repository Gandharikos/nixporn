{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "ghostty";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
  theme = pkgs.writeText "${themeName}-ghostty" ''
    background = ${ansi.bg}
    foreground = ${ansi.fg}
    palette = 0=${ansi.black}
    palette = 1=${ansi.red}
    palette = 2=${ansi.green}
    palette = 3=${ansi.yellow}
    palette = 4=${ansi.blue}
    palette = 5=${ansi.magenta}
    palette = 6=${ansi.cyan}
    palette = 7=${ansi.white}
    palette = 8=${ansi.bright_black}
    palette = 9=${ansi.bright_red}
    palette = 10=${ansi.bright_green}
    palette = 11=${ansi.bright_yellow}
    palette = 12=${ansi.bright_blue}
    palette = 13=${ansi.bright_magenta}
    palette = 14=${ansi.bright_cyan}
    palette = 15=${ansi.bright_white}
  '';
in
{
  config = lib.mkIf enable {
    xdg.configFile."ghostty/themes/${themeName}".source = theme;
    programs.ghostty.settings.theme = "light:${themeName},dark:${themeName}";
  };
}
