{
  colorschemeName,
  targetDir,
}:
let
  specific = targetDir + "/${colorschemeName}.nix";
in
{
  imports =
    if builtins.pathExists specific then
      [ specific ]
    else
      [
        (import (targetDir + "/generic.nix") { inherit colorschemeName; })
      ];
}
