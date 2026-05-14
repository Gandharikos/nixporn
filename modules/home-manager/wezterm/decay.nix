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
  target = "wezterm";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable;
  themeFile =
    {
      cosmic = "wezterm";
      dark = "wezterm.dark-decay";
      decayce = "wezterm.decayce";
      default = "wezterm";
      light = "wezterm.light-decay";
    }
    .${variant};
in
{
  config = lib.mkIf enable {
    programs.wezterm.extraConfig = ''
      for key, value in pairs(dofile("${sources.terms}/wezterm/${themeFile}.lua")) do
        config[key] = value
      end
    '';
  };
}
