{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "sddm";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}-${accent}";
  themePackage =
    pkgs.runCommandLocal "${themeName}-sddm-theme"
      {
        nativeBuildInputs = [
          pkgs.bash
          pkgs.catppuccin-whiskers
          pkgs.just
        ];
        propagatedBuildInputs = [ pkgs.kdePackages.qtsvg ];
      }
      ''
        cp -r ${sources.sddm} source
        chmod -R u+w source
        cd source
        substituteInPlace justfile \
          --replace-fail '#!/usr/bin/env bash' '#!${lib.getExe pkgs.bash}'
        just build
        mkdir -p $out/share/sddm
        cp -r themes $out/share/sddm/
      '';
in
{
  config = lib.mkIf enable {
    services.displayManager.sddm.theme = themeName;
    environment.systemPackages = [ themePackage ];
  };
}
