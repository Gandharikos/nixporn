{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "tty";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  color =
    name:
    let
      value = catppuccin.palette.${name} or catppuccin.palette.ansi.${name};
    in
    if builtins.isString value then value else catppuccin.palette.ansi.bg;
in
{
  config = lib.mkIf enable {
    console.colors = map (colorName: lib.substring 1 6 (color colorName)) [
      "base"
      "red"
      "green"
      "yellow"
      "blue"
      "pink"
      "teal"
      "subtext1"
      "surface2"
      "red"
      "green"
      "yellow"
      "blue"
      "pink"
      "teal"
      "subtext0"
    ];
  };
}
