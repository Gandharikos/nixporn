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
    programs.fzf.defaultOptions = [
      "--highlight-line"
      "--info=inline-right"
      "--ansi"
      "--layout=reverse"
      "--border=none"
      "--color=bg+:${palette.bg_visual}"
      "--color=bg:${palette.bg_dark}"
      "--color=border:${palette.border_highlight}"
      "--color=fg:${palette.fg}"
      "--color=gutter:${palette.bg_dark}"
      "--color=header:${palette.orange}"
      "--color=hl+:${palette.blue1}"
      "--color=hl:${palette.blue1}"
      "--color=info:${palette.dark3}"
      "--color=marker:${palette.magenta2}"
      "--color=pointer:${palette.magenta2}"
      "--color=prompt:${palette.blue1}"
      "--color=query:${palette.fg}:regular"
      "--color=scrollbar:${palette.border_highlight}"
      "--color=separator:${palette.orange}"
      "--color=spinner:${palette.magenta2}"
    ];
  };
}
