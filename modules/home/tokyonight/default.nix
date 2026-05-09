{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.nixporn.tokyonight;
in
{
  imports = [
    (import ../../targets { colorschemeName = "tokyonight"; })
  ];

  config = mkIf cfg.enable {
    home.sessionVariables.COLORSCHEME_STYLE = cfg.style;
  };
}
