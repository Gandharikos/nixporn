{ colorschemeName }:
import ../target-default.nix {
  inherit colorschemeName;
  targetDir = ./.;
}
