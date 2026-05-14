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

  options.nixporn.k9s.transparent = lib.mkEnableOption "transparent version of k9s";

  config = lib.mkIf cfg.transparent {
    nixporn.k9s.transparent = lib.mkDefault true;
  };
}
