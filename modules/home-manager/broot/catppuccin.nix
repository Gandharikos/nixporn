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
  target = "broot";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeFile = "catppuccin-${flavor}-${accent}.hjson";
in
{
  config = lib.mkIf enable {
    xdg.configFile."broot/skins/${themeFile}".source = "${sources.broot}/${flavor}/${themeFile}";
    programs.broot.settings = {
      imports = [
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
  };
}
