{ colorschemeName }:
import ../generic-adapter.nix {
  inherit colorschemeName;
  target = "all-modules";
}
