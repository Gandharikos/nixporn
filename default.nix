{
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,
}:
let
  packages = import ./packages { inherit pkgs; };
in
{
  packages = lib.filterAttrs (lib.const (
    deriv:
    let
      availableOnHost = lib.meta.availableOn pkgs.stdenv.hostPlatform deriv;
      broken = deriv.meta.broken or false;
      isCross = deriv.stdenv.buildPlatform != deriv.stdenv.targetPlatform;
      isFunction = lib.isFunction deriv;
    in
    isFunction || (!broken && availableOnHost) || isCross
  )) packages;

  shell = import ./shell.nix { inherit pkgs; };
}
