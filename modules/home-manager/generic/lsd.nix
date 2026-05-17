{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "lsd";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.lsd.settings.color.theme = "custom";
    xdg.configFile."lsd/colors.yaml".text = ''
      user: ${ansi.yellow}
      group: ${ansi.yellow}
      permission:
        read: ${ansi.green}
        write: ${ansi.yellow}
        exec: ${ansi.red}
        no-access: ${ansi.bright_black}
      date:
        hour-old: ${ansi.green}
        day-old: ${ansi.yellow}
        older: ${ansi.red}
      size:
        none: ${ansi.bright_black}
        small: ${ansi.green}
        medium: ${ansi.yellow}
        large: ${ansi.red}
      inode:
        valid: ${ansi.blue}
        invalid: ${ansi.bright_black}
      links:
        valid: ${ansi.blue}
        invalid: ${ansi.bright_black}
      tree-edge: ${ansi.bright_black}
      file-type:
        file:
          exec-uid: ${ansi.green}
          uid-no-exec: ${ansi.fg}
          exec-no-uid: ${ansi.green}
          no-exec-no-uid: ${ansi.fg}
        dir:
          uid: ${ansi.blue}
          no-uid: ${ansi.blue}
        pipe: ${ansi.yellow}
        symlink:
          default: ${ansi.cyan}
          broken: ${ansi.red}
          missing-target: ${ansi.red}
        block-device: ${ansi.yellow}
        char-device: ${ansi.yellow}
        socket: ${ansi.magenta}
        special: ${ansi.magenta}
    '';
  };
}
