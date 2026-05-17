{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.nordic.palette) ansi;
  target = "fzf";
  enable = cfg.enable && cfg.colorscheme == "nordic" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.fzf.colors = {
      inherit (ansi) fg;
      "bg+" = ansi.black;
      "fg+" = ansi.bright_white;
      header = ansi.yellow;
      hl = ansi.blue;
      "hl+" = ansi.bright_blue;
      info = ansi.cyan;
      marker = ansi.green;
      pointer = ansi.magenta;
      prompt = ansi.blue;
      spinner = ansi.cyan;
    }
    // lib.optionalAttrs (!cfg.transparent) {
      inherit (ansi) bg;
    };
  };
}
