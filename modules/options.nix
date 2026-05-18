{
  cfg,
  colorschemes,
  lib,
}:
let
  inherit (lib)
    genAttrs
    mkEnableOption
    mkOption
    optionalAttrs
    types
    ;

  resourcePathType = types.coercedTo types.package toString types.path;
  targetsWithoutGlobalEnable = [
    "qt5ct"
  ];

  targetOptions = genAttrs colorschemes.targetNames (
    name:
    let
      useGlobalEnable = !(builtins.elem name targetsWithoutGlobalEnable);
    in
    {
      enable = mkOption (
        {
          type = types.bool;
          default = if useGlobalEnable then cfg.enable else false;
          description = "Whether to enable the ${name} colorscheme target.";
        }
        // optionalAttrs useGlobalEnable {
          defaultText = "config.nixporn.enable";
        }
      );
    }
  );

  baseOptions = {
    enable = mkEnableOption "nixporn colorscheme integration";

    apply = mkOption {
      type = types.bool;
      default = true;
      description = "Whether targets should apply colorscheme configuration by default.";
    };

    transparent = mkEnableOption "transparent colorscheme variants";

    colorscheme = mkOption {
      type = types.enum colorschemes.colorschemeNames;
      default = "catppuccin";
      description = "The active colorscheme.";
    };

    wallpaper = mkOption {
      type = types.nullOr resourcePathType;
      default = null;
      description = "The wallpaper path.";
    };

    avatar = mkOption {
      type = types.nullOr resourcePathType;
      default = null;
      description = "The avatar path.";
    };

    palette = mkOption {
      type = types.attrs;
      readOnly = true;
      description = "The palette for the active colorscheme.";
    };

    colorschemes = genAttrs colorschemes.colorschemeNames (
      name:
      mkOption {
        type = types.submodule {
          options = colorschemes.mkColorschemeOptions name;
        };
        default = { };
        description = "Configuration for ${name}.";
      }
    );
  };
in
baseOptions // targetOptions
