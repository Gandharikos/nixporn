{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) palette;
  target = "fzf";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fzf = {
      defaultOptions = [
        "--highlight-line"
        "--info=inline-right"
        "--ansi"
        "--layout=reverse"
        "--border=none"
      ];

      colors = {
        "bg+" = palette.bg_visual;
        bg = palette.bg_dark;
        border = palette.border_highlight;
        inherit (palette) fg;
        gutter = palette.bg_dark;
        header = palette.orange;
        "hl+" = palette.blue1;
        hl = palette.blue1;
        info = palette.dark3;
        marker = palette.magenta2;
        pointer = palette.magenta2;
        prompt = palette.blue1;
        query = "${palette.fg}:regular";
        scrollbar = palette.border_highlight;
        separator = palette.orange;
        spinner = palette.magenta2;
      };
    };
  };
}
