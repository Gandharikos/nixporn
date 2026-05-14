{ lib, ... }:
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.swaync = {
    font = lib.mkOption {
      type = lib.types.str;
      default = "Ubuntu Nerd Font";
      description = "Font to use for the notification center";
    };

    fontSize = lib.mkOption {
      type = lib.types.str;
      default = "14";
      description = "Font size to use for the notification center";
    };
  };
}
