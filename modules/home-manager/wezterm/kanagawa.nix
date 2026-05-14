{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) kanagawa;
  inherit (kanagawa) variant;
  source = pkgs.nixporn.kanagawa;
  target = "wezterm";
  supported = {
    dragon = "kanagawa-dragon.lua";
    wave = "kanagawa.lua";
  };
  enable =
    cfg.enable
    && cfg.colorscheme == "kanagawa"
    && cfg.${target}.enable
    && builtins.hasAttr variant supported;
in
{
  config = lib.mkIf enable {
    programs.wezterm.extraConfig = ''
      for key, value in pairs(dofile("${source}/extras/wezterm/${supported.${variant}}")) do
        config[key] = value
      end
    '';
  };
}
