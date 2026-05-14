{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "swaync";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific && config.services.swaync.enable;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      services.swaync.style = ''
        * {
          font-family: "${cfg.${target}.font}";
          font-size: ${cfg.${target}.fontSize}px;
        }

        @define-color background ${ansi.bg};
        @define-color background-alt ${ansi.black};
        @define-color foreground ${ansi.fg};
        @define-color accent ${ansi.blue};
        @define-color success ${ansi.green};
        @define-color warning ${ansi.yellow};
        @define-color error ${ansi.red};
        @define-color muted ${ansi.bright_black};
      '';
    }
  );
}
