{ pkgs, src }:
import ./mk-theme-package.nix {
  inherit pkgs src;
  name = "gruvbox";
}
