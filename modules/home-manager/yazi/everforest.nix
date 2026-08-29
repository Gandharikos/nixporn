{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) everforest;
  target = "yazi";
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.${target}.enable;
  useNativeFlavor = everforest.mode == "dark" && everforest.contrast == "medium";
  flavorName = "everforest-medium";
in
{
  config = lib.mkIf enable {
    programs.yazi = {
      flavors = lib.mkIf useNativeFlavor {
        ${flavorName} = pkgs.nixporn.everforest.yazi;
      };
      theme =
        if useNativeFlavor then
          lib.nixporn.yaziFlavorTheme flavorName
        else
          import ../generic/yazi-theme.nix { inherit (cfg.palette) ansi; };
    };
  };
}
