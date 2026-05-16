{ config, lib, ... }:
let
  inherit (config.nixporn.palette) ansi;

  mkBibataColorOption =
    {
      default,
      description,
    }:
    lib.mkOption {
      type = lib.types.str;
      inherit default description;
    };
in
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.cursors = {
    accent = lib.mkOption {
      type = lib.types.enum [
        "auto"
        "dark"
        "light"
      ];
      default = "auto";
      description = "The cursor accent. auto uses the active colorscheme accent.";
    };

    bibata = {
      baseColor = mkBibataColorOption {
        default = ansi.bg;
        description = "Base color for generated Bibata cursors.";
      };

      outlineColor = mkBibataColorOption {
        default = ansi.fg;
        description = "Outline color for generated Bibata cursors.";
      };

      watchBackgroundColor = mkBibataColorOption {
        default = ansi.red;
        description = "Watch background color for generated Bibata cursors.";
      };
    };
  };
}
