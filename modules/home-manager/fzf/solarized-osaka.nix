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
    programs.fzf.defaultOptions = [
      "--highlight-line"
      "--info=inline-right"
      "--ansi"
      "--layout=reverse"
      "--border=none"
      "--color=bg+:${palette.bg_highlight}"
      "--color=bg:${palette.bg}"
      "--color=border:${palette.base02}"
      "--color=fg:${palette.base0}"
      "--color=gutter:${palette.bg}"
      "--color=header:${palette.orange}"
      "--color=hl+:${palette.orange}"
      "--color=hl:${palette.orange}"
      "--color=info:${palette.base00}"
      "--color=marker:${palette.orange}"
      "--color=pointer:${palette.orange}"
      "--color=prompt:${palette.orange}"
      "--color=query:${palette.base0}:regular"
      "--color=scrollbar:${palette.base02}"
      "--color=separator:${palette.base02}"
      "--color=spinner:${palette.orange}"
    ];
  };
}
