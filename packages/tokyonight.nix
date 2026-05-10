{
  pkgs,
  src,
  spotifySrc,
}:
let
  package = import ./mk-theme-package.nix {
    inherit pkgs src;
    name = "tokyonight";
    extraSources.spotify = spotifySrc;
  };
in
package.overrideAttrs (old: {
  buildCommand = old.buildCommand + ''
    ln -s ${spotifySrc} "$out/share/nixporn/tokyonight/spotify"
  '';
})
