{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) palette;
  target = "fzf";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
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
        "bg+" = palette.bg_highlight;
        border = palette.base02;
        fg = palette.base0;
        header = palette.orange;
        "hl+" = palette.orange;
        hl = palette.orange;
        info = palette.base00;
        marker = palette.orange;
        pointer = palette.orange;
        prompt = palette.orange;
        query = "${palette.base0}:regular";
        scrollbar = palette.base02;
        separator = palette.base02;
        spinner = palette.orange;
      }
      // lib.optionalAttrs (!cfg.transparent) {
        inherit (palette) bg;
        gutter = palette.bg;
      };
    };
  };
}
