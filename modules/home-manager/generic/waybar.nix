{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "waybar";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.waybar.style = lib.mkBefore ''
      @define-color nixporn_bg ${ansi.bg};
      @define-color nixporn_fg ${ansi.fg};
      @define-color nixporn_black ${ansi.black};
      @define-color nixporn_red ${ansi.red};
      @define-color nixporn_green ${ansi.green};
      @define-color nixporn_yellow ${ansi.yellow};
      @define-color nixporn_blue ${ansi.blue};
      @define-color nixporn_magenta ${ansi.magenta};
      @define-color nixporn_cyan ${ansi.cyan};
      @define-color nixporn_white ${ansi.white};
    '';
  };
}
