{
  pkgs,
  name,
  src,
  extraSources ? { },
}:
pkgs.runCommand "nixporn-${name}-themes"
  {
    passthru = {
      inherit src;
    } // extraSources;
    meta = {
      description = "Theme configuration sources for ${name}";
      platforms = pkgs.lib.platforms.all;
    };
  }
  ''
    mkdir -p "$out/share/nixporn/${name}"
    ln -s ${src} "$out/share/nixporn/${name}/source"
  ''
