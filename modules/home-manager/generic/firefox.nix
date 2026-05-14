{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "firefox";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.firefox.policies.Preferences = {
        "browser.theme.content-theme" =
          if cfg.colorschemes.${colorscheme}.polarity == "light" then 1 else 0;
        "browser.theme.toolbar-theme" =
          if cfg.colorschemes.${colorscheme}.polarity == "light" then 1 else 0;
        "browser.display.background_color" = ansi.bg;
        "browser.display.foreground_color" = ansi.fg;
        "browser.anchor_color" = ansi.blue;
        "browser.visited_color" = ansi.magenta;
        "reader.color_scheme" = cfg.colorschemes.${colorscheme}.polarity;
        "reader.custom_colors.background" = ansi.bg;
        "reader.custom_colors.foreground" = ansi.fg;
        "reader.custom_colors.unvisited-links" = ansi.blue;
        "reader.custom_colors.visited-links" = ansi.magenta;
      };
    }
  );
}
