{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "qt5ct";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  inherit (cfg.palette) ansi;

  alphaColor = alpha: color: "#${alpha}${lib.removePrefix "#" color}";
  opaque = alphaColor "ff";
  placeholder = alphaColor "80" ansi.bright_black;
  default = if colorschemeCfg.polarity == "dark" then "#ffffffff" else "#ff000000";

  colorScheme = pkgs.writeText "nixporn-${colorschemeCfg.slug}.conf" ''
    [ColorScheme]
    active_colors=${
      lib.concatStringsSep ", " [
        (opaque ansi.fg)
        (opaque ansi.black)
        (opaque ansi.bright_black)
        (opaque ansi.black)
        (opaque ansi.bg)
        (opaque ansi.bg)
        (opaque ansi.fg)
        (opaque ansi.bright_white)
        (opaque ansi.fg)
        (opaque ansi.bg)
        (opaque ansi.bg)
        (opaque ansi.black)
        (opaque ansi.blue)
        (opaque ansi.bg)
        (opaque ansi.blue)
        (opaque ansi.magenta)
        (opaque ansi.black)
        default
        (opaque ansi.bg)
        (opaque ansi.fg)
        placeholder
        (opaque ansi.blue)
      ]
    }
    inactive_colors=${
      lib.concatStringsSep ", " [
        (opaque ansi.white)
        (opaque ansi.bg)
        (opaque ansi.black)
        (opaque ansi.black)
        (opaque ansi.bg)
        (opaque ansi.bg)
        (opaque ansi.white)
        (opaque ansi.fg)
        (opaque ansi.white)
        (opaque ansi.bg)
        (opaque ansi.bg)
        (opaque ansi.black)
        (opaque ansi.black)
        (opaque ansi.white)
        (opaque ansi.white)
        (opaque ansi.white)
        (opaque ansi.black)
        default
        (opaque ansi.bg)
        (opaque ansi.fg)
        placeholder
        (opaque ansi.black)
      ]
    }
    disabled_colors=${
      lib.concatStringsSep ", " [
        (opaque ansi.bright_black)
        (opaque ansi.black)
        (opaque ansi.black)
        (opaque ansi.black)
        (opaque ansi.bg)
        (opaque ansi.bg)
        (opaque ansi.bright_black)
        (opaque ansi.fg)
        (opaque ansi.bright_black)
        (opaque ansi.bg)
        (opaque ansi.bg)
        (opaque ansi.black)
        (opaque ansi.bg)
        (opaque ansi.bright_black)
        (opaque ansi.bright_blue)
        (opaque ansi.bright_magenta)
        (opaque ansi.black)
        default
        (opaque ansi.bg)
        (opaque ansi.fg)
        placeholder
        (opaque ansi.bg)
      ]
    }
  '';
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      qt = lib.genAttrs [ "qt5ctSettings" "qt6ctSettings" ] (_: {
        Appearance = {
          custom_palette = true;
          color_scheme_path = colorScheme;
        };
      });
    }
  );
}
