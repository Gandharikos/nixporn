{ lib, ... }:
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.dunst.prefix = lib.mkOption {
    type = lib.types.str;
    default = "00";
    description = "Prefix to use for the dunst drop-in file.";
  };
}
