{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "newsboat";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.newsboat.extraConfig = lib.mkBefore ''
      color background          ${ansi.fg}           ${ansi.bg}
      color listnormal          ${ansi.fg}           ${ansi.bg}
      color listfocus           ${ansi.bg}           ${ansi.blue}       bold
      color listnormal_unread   ${ansi.blue}         ${ansi.bg}         bold
      color listfocus_unread    ${ansi.bg}           ${ansi.blue}       bold
      color info                ${ansi.fg}           ${ansi.black}
      color article             ${ansi.fg}           ${ansi.bg}

      highlight all "---.*---"                              ${ansi.yellow}
      highlight feedlist ".*(0/0))"                         ${ansi.bright_black}
      highlight article "^(Feed|Title|Author|Link|Date):.*" ${ansi.magenta} default bold
      highlight article "https?://[^ ]+"                    ${ansi.blue}    default underline
      highlight article "\\[[0-9]+\\]"                      ${ansi.cyan}
      highlight article "\\[image\\ [0-9]+\\]"              ${ansi.yellow}
      highlight article "\\[embedded flash: [0-9][0-9]*\\]" ${ansi.yellow}
      highlight article ":.*\\(link\\)$"                    ${ansi.blue}
      highlight article ":.*\\(image\\)$"                   ${ansi.yellow}
      highlight article ":.*\\(embedded flash\\)$"          ${ansi.yellow}
    '';
  };
}
