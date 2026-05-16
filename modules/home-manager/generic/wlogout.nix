{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "wlogout";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.wlogout.style = lib.concatStrings [
        ''
          * {
            background-image: none;
            box-shadow: none;
          }

          window {
            background-color: alpha(${ansi.bg}, 0.90);
          }

          button {
            border-radius: 0;
            border: 1px solid ${ansi.blue};
            color: ${ansi.fg};
            background-color: ${ansi.black};
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
            text-decoration-color: ${ansi.fg};
          }

          button:focus,
          button:active,
          button:hover {
            background-color: ${ansi.bright_black};
            color: ${ansi.bright_white};
            outline-style: none;
          }

          #lock {
            border-color: ${ansi.blue};
          }

          #logout,
          #suspend,
          #hibernate {
            border-color: ${ansi.yellow};
          }

          #reboot {
            border-color: ${ansi.magenta};
          }

          #shutdown {
            border-color: ${ansi.red};
          }
        ''
        cfg.${target}.extraStyle
      ];
    }
  );
}
