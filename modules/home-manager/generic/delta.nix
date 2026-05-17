{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "delta";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.delta.options = {
      commit-decoration-style = "bold ${ansi.magenta}";
      file-decoration-style = "bold ${ansi.blue}";
      file-style = "bold ${ansi.blue}";
      hunk-header-decoration-style = ansi.bright_black;
      hunk-header-file-style = "bold ${ansi.blue}";
      hunk-header-line-number-style = ansi.bright_black;
      hunk-header-style = "syntax ${ansi.magenta}";
      line-numbers-left-style = ansi.bright_black;
      line-numbers-minus-style = ansi.red;
      line-numbers-plus-style = ansi.green;
      line-numbers-right-style = ansi.bright_black;
      line-numbers-zero-style = ansi.bright_black;
      minus-emph-style = "syntax ${ansi.bright_red}";
      minus-empty-line-marker-style = "normal ${ansi.red}";
      minus-non-emph-style = "syntax ${ansi.red}";
      minus-style = "syntax ${ansi.red}";
      plus-emph-style = "syntax ${ansi.bright_green}";
      plus-empty-line-marker-style = "normal ${ansi.green}";
      plus-non-emph-style = "syntax ${ansi.green}";
      plus-style = "syntax ${ansi.green}";
      zero-style = "syntax";
    };
  };
}
