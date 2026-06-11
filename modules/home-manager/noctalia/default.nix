{ lib, ... }:
{
  imports = lib.nixporn.scanPaths ./.;
}
