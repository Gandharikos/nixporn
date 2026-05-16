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
    environment.systemPackages = [
      pkgs.rose-pine-cursor
      pkgs.rose-pine-hyprcursor
    ];
    environment.variables = {
      XCURSOR_THEME = cursorName;
      HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    };
  };
}
