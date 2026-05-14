{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) cyberdream;
  inherit (cyberdream) slug;
  source = pkgs.nixporn.cyberdream;
  target = "k9s";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
  enableXdgConfig = !pkgs.stdenv.hostPlatform.isDarwin || config.xdg.enable;
  themeFile = "${slug}.yml";
  themePath = "k9s/skins/${themeFile}";
  theme = "${source}/extras/k9s/${themeFile}";
in
{
  config = lib.mkIf enable (
    lib.mkMerge [
      (lib.mkIf (!enableXdgConfig) {
        home.file."Library/Application Support/${themePath}".source = theme;
      })

      (lib.mkIf enableXdgConfig {
        xdg.configFile.${themePath}.source = theme;
      })

      {
        programs.k9s.settings.k9s.ui.skin = slug;
      }
    ]
  );
}
