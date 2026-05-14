{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent palette;
  target = "fzf";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  colors = lib.mapAttrs (_: color: palette.${color}) {
    "bg+" = "surface0";
    bg = "base";
    spinner = "rosewater";
    hl = accent;
    fg = "text";
    header = accent;
    info = accent;
    pointer = accent;
    marker = accent;
    "fg+" = "text";
    prompt = accent;
    "hl+" = accent;
  };
in
{
  config = lib.mkIf enable {
    programs.fzf = {
      inherit colors;
    };
  };
}
