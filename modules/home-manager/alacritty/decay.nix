{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) decay;
  inherit (decay) variant;
  sources = pkgs.nixporn.decay;
  target = "alacritty";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable;
  themeFile =
    {
      cosmic = "decay";
      dark = "dark-decay";
      decayce = "decayce";
      default = "decay";
      light = "light-decay";
    }
    .${variant};
in
{
  config = lib.mkIf enable {
    programs.alacritty.settings.general.import = lib.mkBefore [
      "${sources.terms}/alacritty/${themeFile}.toml"
    ];
  };
}
