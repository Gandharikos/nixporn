{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.nixporn.catppuccin;
in
{
  imports = [
    (import ../../targets { colorschemeName = "catppuccin"; })
  ];

  config = mkIf cfg.enable {
    home.sessionVariables = {
      COLORSCHEME_FLAVOR = cfg.flavor;
      COLORSCHEME_ACCENT = cfg.accent;
    };
  };
}
