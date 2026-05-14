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
  target = "kvantum";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName = "catppuccin-${flavor}-${accent}";
in
{
  config = lib.mkIf enable {
    xdg.configFile = {
      "Kvantum/${themeName}".source = "${sources.kvantum}/themes/${themeName}";
      "Kvantum/kvantum.kvconfig" = lib.mkIf cfg.${target}.apply {
        text = ''
          [General]
          theme=${themeName}
        '';
      };
    };
  };
}
