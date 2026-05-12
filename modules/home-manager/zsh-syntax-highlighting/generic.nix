{ colorschemeName }:
import ../generic-adapter.nix {
  inherit colorschemeName;
  target = "zsh-syntax-highlighting";
}
