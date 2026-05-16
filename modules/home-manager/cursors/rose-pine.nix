{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "cursors";
  colorscheme = cfg.colorschemes.rose-pine;
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  cursorVariant =
    if cfg.${target}.accent == "auto" then
      colorscheme.variant
    else if cfg.${target}.accent == "light" then
      "dawn"
    else
      "main";
  cursorName =
    if cursorVariant == "dawn" then "BreezeX-RosePineDawn-Linux" else "BreezeX-RosePine-Linux";
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      name = cursorName;
      package = pkgs.rose-pine-cursor;
    };

    home.packages = [ pkgs.rose-pine-hyprcursor ];
    home.sessionVariables.HYPRCURSOR_THEME = "rose-pine-hyprcursor";
  };
}
