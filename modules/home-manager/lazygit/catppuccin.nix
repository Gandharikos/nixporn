{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent palette;
  accentColor = palette.${accent};
  target = "lazygit";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.lazygit.settings.gui = {
      authorColors."*" = accentColor;
      theme = {
        activeBorderColor = [
          accentColor
          "bold"
        ];
        inactiveBorderColor = [ palette.subtext0 ];
        searchingActiveBorderColor = [
          palette.yellow
          "bold"
        ];
        optionsTextColor = [ palette.blue ];
        selectedLineBgColor = [ palette.surface0 ];
        inactiveViewSelectedLineBgColor = [ palette.overlay0 ];
        cherryPickedCommitFgColor = [ accentColor ];
        cherryPickedCommitBgColor = [ palette.surface1 ];
        markedBaseCommitFgColor = [ palette.blue ];
        markedBaseCommitBgColor = [ palette.yellow ];
        unstagedChangesColor = [ palette.red ];
        defaultFgColor = [ palette.text ];
      };
    };
  };
}
