{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.gruvbox.palette) ansi;
  target = "fzf";
  enable = cfg.enable && cfg.colorscheme == "gruvbox" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fzf.colors = {
      inherit (ansi) bg fg;
      "bg+" = ansi.black;
      "fg+" = ansi.bright_white;
      header = ansi.yellow;
      hl = ansi.red;
      "hl+" = ansi.bright_red;
      info = ansi.blue;
      marker = ansi.cyan;
      pointer = ansi.magenta;
      prompt = ansi.green;
      spinner = ansi.yellow;
    };
  };
}
