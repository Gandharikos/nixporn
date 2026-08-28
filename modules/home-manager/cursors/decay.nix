{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  polarity = cfg.colorschemes.decay.polarity;
  cursorColor =
    if cfg.cursors.accent == "auto" then
      if polarity == "light" then "dark" else "light"
    else
      cfg.cursors.accent;
  cursorName = "phinger-cursors-${cursorColor}";
  enable = cfg.enable && cfg.colorscheme == "decay" && cfg.cursors.enable;
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      name = cursorName;
      package = pkgs.nixporn.decay.cursors;
    };
  };
}
