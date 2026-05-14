{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "fish";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.fish.interactiveShellInit = ''
        set -g fish_color_normal ${ansi.fg}
        set -g fish_color_command ${ansi.blue}
        set -g fish_color_keyword ${ansi.magenta}
        set -g fish_color_quote ${ansi.green}
        set -g fish_color_redirection ${ansi.cyan}
        set -g fish_color_end ${ansi.yellow}
        set -g fish_color_error ${ansi.red}
        set -g fish_color_param ${ansi.fg}
        set -g fish_color_comment ${ansi.bright_black}
        set -g fish_color_selection --background=${ansi.black}
        set -g fish_color_search_match --background=${ansi.black}
        set -g fish_color_operator ${ansi.cyan}
        set -g fish_color_escape ${ansi.magenta}
        set -g fish_color_autosuggestion ${ansi.bright_black}
        set -g fish_color_cancel ${ansi.red}
      '';
    }
  );
}
