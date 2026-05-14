{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "zsh-syntax-highlighting";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.zsh.syntaxHighlighting.styles = {
        comment = "fg=${ansi.bright_black}";
        alias = "fg=${ansi.blue}";
        suffix-alias = "fg=${ansi.blue}";
        global-alias = "fg=${ansi.blue}";
        function = "fg=${ansi.blue}";
        command = "fg=${ansi.green}";
        precommand = "fg=${ansi.green}";
        autodirectory = "fg=${ansi.cyan}";
        single-hyphen-option = "fg=${ansi.yellow}";
        double-hyphen-option = "fg=${ansi.yellow}";
        back-quoted-argument = "fg=${ansi.magenta}";
        builtin = "fg=${ansi.blue}";
        reserved-word = "fg=${ansi.magenta}";
        hashed-command = "fg=${ansi.green}";
        path = "fg=${ansi.cyan}";
        path_pathseparator = "fg=${ansi.bright_black}";
        globbing = "fg=${ansi.cyan}";
        history-expansion = "fg=${ansi.magenta}";
        command-substitution = "fg=${ansi.fg}";
        command-substitution-delimiter = "fg=${ansi.bright_black}";
        process-substitution = "fg=${ansi.fg}";
        process-substitution-delimiter = "fg=${ansi.bright_black}";
        single-quoted-argument = "fg=${ansi.green}";
        double-quoted-argument = "fg=${ansi.green}";
        dollar-quoted-argument = "fg=${ansi.green}";
        rc-quote = "fg=${ansi.yellow}";
        dollar-double-quoted-argument = "fg=${ansi.cyan}";
        back-double-quoted-argument = "fg=${ansi.cyan}";
        back-dollar-quoted-argument = "fg=${ansi.cyan}";
        assign = "fg=${ansi.yellow}";
        redirection = "fg=${ansi.cyan}";
        named-fd = "fg=${ansi.cyan}";
        numeric-fd = "fg=${ansi.cyan}";
        unknown-token = "fg=${ansi.red}";
      };
    }
  );
}
