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
  config = mkIf (targetEnabled "opencode") {
    programs.opencode.tui.theme = mkIf (config.programs.opencode.enable or false) slug;
    xdg.configFile."opencode/themes/${slug}.json" = mkIf (config.programs.opencode.enable or false) {
      text = builtins.toJSON {
        name = slug;
        type = "dark";
        primary = colors.blue;
        secondary = colors.magenta;
        accent = colors.cyan;
        background = colors.bg;
        foreground = colors.fg;
        error = colors.red;
        warning = colors.yellow;
        success = colors.green;
      };
    };
  };
}
