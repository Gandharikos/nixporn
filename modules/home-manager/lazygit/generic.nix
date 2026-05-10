{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}@moduleArgs:
let
  common = import ../common.nix { inherit colorschemeName; } moduleArgs;
  inherit (common)
    cfg
    colors
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
in
{
  config = mkIf (targetEnabled "lazygit") {
    programs.lazygit.settings.gui.theme = mkIf (config.programs.lazygit.enable or false) (
      with colors;
      {
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
        unstagedChangesColor = [ red ];
        defaultFgColor = [ fg ];
      }
    );
  };
}
