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
  config = mkIf (targetEnabled "discord") {
    programs.nixcord.config = mkIf (config.programs.nixcord.enable or false) {
      frameless = mkDefault true;
      transparent = mkDefault cfg.general.transparent;
      enabledThemes = [ "${slug}.css" ];
    };
    home.file = mkIf (config.programs.nixcord.enable or false) {
      "${config.programs.nixcord.configDir}/themes/${slug}.css".text = with colors; ''
        :root {
          --background-primary: ${bg};
          --background-secondary: ${bg_dark};
          --background-tertiary: ${black};
          --text-normal: ${fg};
          --text-muted: ${comment};
          --interactive-normal: ${fg_dark};
          --interactive-hover: ${fg};
          --brand-experiment: ${blue};
          --mention-background: ${bg_highlight};
          --mention-foreground: ${yellow};
        }
      '';
    };
  };
}
