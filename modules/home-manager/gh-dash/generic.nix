{ colorschemeName }:
import ../generic-adapter.nix {
  inherit colorschemeName;
  target = "gh-dash";
}
