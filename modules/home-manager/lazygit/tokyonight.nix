{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixporn.colorscheme) palette;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."lazygit";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.lazygit.settings.gui.theme = with palette; {
      activeBorderColor = [
        orange
        "bold"
      ];
      inactiveBorderColor = [ border_highlight ];
      searchingActiveBorderColor = [
        orange
        "bold"
      ];
      optionsTextColor = [ blue ];
      selectedLineBgColor = [ bg_visual ];
      cherryPickedCommitFgColor = [ blue ];
      cherryPickedCommitBgColor = [ magenta ];
      markedBaseCommitFgColor = [ blue ];
      markedBaseCommitBgColor = [ yellow ];
      unstagedChangesColor = [ red1 ];
      defaultFgColor = [ fg ];
    };
  };
}
