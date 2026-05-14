{ lib, ... }:
{
  _class = "homeManager";
  imports = lib.nixporn.scanPaths ./.;
}
