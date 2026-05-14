{ lib, ... }:
{
  _class = "nixos";
  imports = lib.nixporn.scanPaths ./.;
}
