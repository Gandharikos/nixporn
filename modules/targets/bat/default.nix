{ colorschemeName }:
let
  specific = ./. + "/${colorschemeName}.nix";
in
{
  imports =
    if builtins.pathExists specific then
      [ specific ]
    else
      [
        (import ./generic.nix { inherit colorschemeName; })
      ];
}
