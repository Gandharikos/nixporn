{ colorschemeName }:
import ../generic-adapter.nix {
  inherit colorschemeName;
  target = "xfce4-terminal";
}
