{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  target = "skim";
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
    programs.skim.defaultOptions = [
      "--color=bg:${color "base"},bg+:${color "surface0"},spinner:${color "rosewater"},hl:${color "red"}"
      "--color=fg:${color "text"},header:${color "red"},info:${color "mauve"},pointer:${color "rosewater"}"
      "--color=marker:${color "rosewater"},fg+:${color "text"},prompt:${color "mauve"},hl+:${color "red"}"
    ];
  };
}
