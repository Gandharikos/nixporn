{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) variant;
  colors = import ../generic/kanagawa-colors.nix {
    inherit (cfg) palette;
    inherit variant;
  };
  ansi = cfg.palette.ansi // {
    blue = colors.keyword;
    bright_blue = colors.special;
  };
  target = "yazi";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = import ../generic/yazi-theme.nix { inherit ansi; };
  };
}
