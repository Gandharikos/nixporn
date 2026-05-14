{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  source = pkgs.nixporn.kanagawa;
  target = "broot";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  themeFile = "kanagawa.toml";
in
{
  config = lib.mkIf enable {
    xdg.configFile."broot/skins/${themeFile}".source = "${source}/extras/broot/${themeFile}";
    programs.broot.settings.imports = [
      {
        file = "skins/${themeFile}";
        luma = "light";
      }
      {
        file = "skins/${themeFile}";
        luma = [
          "dark"
          "unknown"
        ];
      }
    ];
  };
}
