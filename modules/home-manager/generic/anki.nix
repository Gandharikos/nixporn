{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "anki";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.anki.addons = [
      (pkgs.ankiAddons.recolor.withConfig {
        config =
          let
            version = builtins.splitVersion pkgs.ankiAddons.recolor.version;
            color = name: light: dark: css: [
              name
              light
              dark
              css
            ];
          in
          {
            version = {
              major = lib.toInt (builtins.elemAt version 0);
              minor = lib.toInt (builtins.elemAt version 1);
            };
            colors = {
              ACCENT_CARD = color "Card mode" ansi.blue ansi.blue "--accent-card";
              ACCENT_DANGER = color "Danger" ansi.red ansi.red "--accent-danger";
              ACCENT_NOTE = color "Note mode" ansi.green ansi.green "--accent-note";
              BORDER = color "Border" ansi.bright_black ansi.bright_black "--border";
              BORDER_FOCUS = color "Border (focused input)" ansi.blue ansi.blue "--border-focus";
              BUTTON_BG = color "Button background" ansi.black ansi.black "--button-bg";
              BUTTON_HOVER = color "Button background (hover)" ansi.bright_black ansi.bright_black [
                "--button-gradient-start"
                "--button-gradient-end"
              ];
              BUTTON_PRIMARY_BG = color "Button Primary Bg" ansi.blue ansi.blue "--button-primary-bg";
              CANVAS = color "Background" ansi.bg ansi.bg [
                "--canvas"
                "--bs-body-bg"
              ];
              CANVAS_ELEVATED = color "Background (elevated)" ansi.black ansi.black "--canvas-elevated";
              CANVAS_INSET = color "Background (inset)" ansi.black ansi.black "--canvas-inset";
              CANVAS_OVERLAY =
                color "Background (menu & tooltip)" ansi.bright_black ansi.bright_black
                  "--canvas-overlay";
              FG = color "Text" ansi.fg ansi.fg [
                "--fg"
                "--bs-body-color"
              ];
              FG_DISABLED = color "Text (disabled)" ansi.bright_black ansi.bright_black "--fg-disabled";
              FG_FAINT = color "Text (faint)" ansi.bright_black ansi.bright_black "--fg-faint";
              FG_LINK = color "Text (link)" ansi.blue ansi.blue "--fg-link";
              FG_SUBTLE = color "Text (subtle)" ansi.bright_black ansi.bright_black "--fg-subtle";
              FLAG_1 = color "Flag 1" ansi.red ansi.red "--flag-1";
              FLAG_2 = color "Flag 2" ansi.yellow ansi.yellow "--flag-2";
              FLAG_3 = color "Flag 3" ansi.yellow ansi.yellow "--flag-3";
              FLAG_4 = color "Flag 4" ansi.green ansi.green "--flag-4";
              FLAG_5 = color "Flag 5" ansi.cyan ansi.cyan "--flag-5";
              FLAG_6 = color "Flag 6" ansi.blue ansi.blue "--flag-6";
            };
          };
      })
    ];
  };
}
