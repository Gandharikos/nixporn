{ colorschemeName }:
import ../generic-adapter.nix {
  inherit colorschemeName;
  target = "k9s";
}
