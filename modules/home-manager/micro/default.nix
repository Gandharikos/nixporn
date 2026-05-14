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

  options.nixporn.micro.transparent = lib.mkEnableOption "transparent version of micro";

  config = lib.mkIf cfg.transparent {
    nixporn.micro.transparent = lib.mkDefault true;
  };
}
