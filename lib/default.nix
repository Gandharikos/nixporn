{ lib }:
let
  colors = import ./colors.nix { inherit lib; };
  paths = import ./paths.nix { inherit lib; };
  strings = import ./strings.nix { inherit lib; };
in
colors // paths // strings
