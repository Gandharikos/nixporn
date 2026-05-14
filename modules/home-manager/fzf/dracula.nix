{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) dracula;
  inherit (dracula) palette;
  target = "fzf";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fzf.colors = {
      "bg+" = palette.selection;
      bg = palette.bg;
      spinner = palette.purple;
      hl = palette.pink;
      fg = palette.fg;
      header = palette.pink;
      info = palette.comment;
      pointer = palette.purple;
      marker = palette.purple;
      "fg+" = palette.fg;
      prompt = palette.purple;
      "hl+" = palette.pink;
    };
  };
}
