{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) palette;
  target = "fzf";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fzf.colors = {
      bg = palette.base;
      "bg+" = palette.overlay;
      border = palette.highlight_med;
      fg = palette.subtle;
      "fg+" = palette.text;
      gutter = palette.base;
      header = palette.pine;
      hl = palette.rose;
      "hl+" = palette.rose;
      info = palette.foam;
      marker = palette.love;
      pointer = palette.iris;
      prompt = palette.subtle;
      spinner = palette.gold;
    };
  };
}
