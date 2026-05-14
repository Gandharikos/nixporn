{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
in
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.cava.transparent = lib.mkEnableOption "transparent version of cava";

  config = lib.mkIf cfg.transparent {
    nixporn.cava.transparent = lib.mkDefault true;
  };
}
