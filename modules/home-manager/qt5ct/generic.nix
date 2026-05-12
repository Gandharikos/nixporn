{ colorschemeName }:
import ../generic-adapter.nix {
  inherit colorschemeName;
  target = "qt5ct";
}
