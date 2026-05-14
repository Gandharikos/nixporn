{ lib, ... }:
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.wlogout = {
    iconStyle = lib.mkOption {
      type = lib.types.enum [
        "wlogout"
        "wleave"
      ];
      description = "Icon style to set in ~/.config/wlogout/style.css";
      default = "wlogout";
      example = lib.literalExpression "wleave";
    };

    extraStyle = lib.mkOption {
      type = lib.types.lines;
      description = "Additional CSS to put in ~/.config/wlogout/style.css";
      default = "";
      example = lib.literalExpression ''
        button {
          border-radius: 2px;
        }

        #lock {
          background-image: url("''${config.gtk.iconTheme.package}/share/icons/''${config.gtk.iconTheme.name}/apps/scalable/system-lock-screen.svg");
        }
      '';
    };
  };
}
