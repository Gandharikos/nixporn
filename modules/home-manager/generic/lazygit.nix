{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "lazygit";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.lazygit.settings.gui.theme = {
      activeBorderColor = [
        ansi.blue
        "bold"
      ];
      inactiveBorderColor = [ ansi.bright_black ];
      searchingActiveBorderColor = [
        ansi.yellow
        "bold"
      ];
      optionsTextColor = [ ansi.cyan ];
      selectedLineBgColor = [ ansi.black ];
      cherryPickedCommitBgColor = [ ansi.black ];
      cherryPickedCommitFgColor = [ ansi.bright_black ];
      unstagedChangesColor = [ ansi.red ];
      defaultFgColor = [ ansi.fg ];
    };
  };
}
