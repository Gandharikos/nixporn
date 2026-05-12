{ colorschemeName }:
import ../generic-adapter.nix {
  inherit colorschemeName;
  target = "vesktop";
}
