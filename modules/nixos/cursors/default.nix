{ lib, ... }:
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.cursors.accent = lib.mkOption {
    type = lib.types.enum [
      "auto"
      "dark"
      "light"
    ];
    default = "auto";
    description = "The cursor accent. auto uses the active colorscheme accent.";
  };
}
