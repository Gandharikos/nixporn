{ colorschemeName }:
let
  targetNames = import ../../nixporn/target-names.nix;
in
{
  imports = builtins.map (
    target: import (./. + "/${target}") { inherit colorschemeName; }
  ) targetNames;
}
