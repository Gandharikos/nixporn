{
  lib,
  colorschemes,
  supportedColorschemes,
  targetNames,
}:
let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types)
    attrs
    bool
    coercedTo
    enum
    nullOr
    path
    pathInStore
    singleLineStr
    str
    ;

  resourcePathType = coercedTo path (src: "${src}") pathInStore;

  mkColorschemeOptions = {
    colorscheme = {
      name = mkOption {
        type = enum supportedColorschemes;
        default = "catppuccin";
        description = "The canonical colorscheme slug to apply.";
      };
      variant = mkOption {
        type = nullOr singleLineStr;
        default = null;
        description = "The selected colorscheme variant. Null uses the colorscheme default.";
      };
      accent = mkOption {
        type = nullOr singleLineStr;
        default = null;
        description = "The selected accent for colorschemes that support accents.";
      };
      slug = mkOption {
        type = nullOr str;
        default = null;
        description = "The resolved colorscheme slug.";
      };
      palette = mkOption {
        type = nullOr attrs;
        default = null;
        description = "The resolved colorscheme palette.";
      };
    };
  };

  mkCoreOptions = {
    enable = mkEnableOption "nixporn colorscheme integration";

    wallpaper = mkOption {
      type = nullOr resourcePathType;
      default = null;
      description = "Wallpaper path exposed for downstream modules to consume.";
    };

    avatar = mkOption {
      type = nullOr resourcePathType;
      default = null;
      description = "Avatar image path exposed for downstream modules to consume.";
    };

    wallpaperScalingMode = mkOption {
      type = enum [
        "stretch"
        "fill"
        "fit"
        "center"
        "tile"
      ];
      default = "fill";
      description = "Preferred wallpaper scaling mode for downstream consumers.";
    };
  };

  mkGeneralOptions = {
    general = {
      transparent = mkEnableOption "transparent colorscheme surfaces" // {
        default = true;
      };
      pad = {
        left = mkOption {
          type = singleLineStr;
          default = "";
          description = "The left padding of status bars.";
        };
        right = mkOption {
          type = singleLineStr;
          default = "";
          description = "The right padding of status bars.";
        };
      };
    };
  };

  mkTargetOptions =
    cfg:
    genAttrs targetNames (name: {
      enable = mkOption {
        type = bool;
        default = cfg.enable;
        defaultText = "config.nixporn.enable";
        description = "Whether to apply the nixporn colorscheme adapter for ${name}.";
      };
    });
in
{
  inherit
    mkColorschemeOptions
    mkCoreOptions
    mkGeneralOptions
    mkTargetOptions
    ;

  mkNixpornOptions =
    cfg:
    mkCoreOptions
    // colorschemes
    // mkColorschemeOptions
    // mkGeneralOptions
    // {
      targets = mkTargetOptions cfg;
    };
}
