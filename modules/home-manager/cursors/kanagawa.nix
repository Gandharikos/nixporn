{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  polarity = cfg.colorschemes.kanagawa.polarity;
  cursorColor =
    if cfg.cursors.accent == "auto" then
      if polarity == "light" then "dark" else "light"
    else
      cfg.cursors.accent;
  cursorName = if cursorColor == "light" then "Vimix-white-cursors" else "Vimix-cursors";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.cursors.enable;
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      name = cursorName;
      package = pkgs.nixporn.kanagawa.cursors;
    };
  };
}
