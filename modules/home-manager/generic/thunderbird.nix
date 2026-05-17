{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "thunderbird";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  polarity = cfg.colorschemes.${colorscheme}.polarity;

  css = ''
    :root {
      --nixporn-bg: ${ansi.bg};
      --nixporn-bg-alt: ${ansi.black};
      --nixporn-fg: ${ansi.fg};
      --nixporn-muted: ${ansi.bright_black};
      --nixporn-accent: ${ansi.blue};
      --nixporn-danger: ${ansi.red};
    }

    window,
    dialog,
    #messengerWindow,
    #mail-toolbox,
    #navigation-toolbox,
    #folderPane,
    #threadTree,
    #messagepanebox,
    #messageHeader,
    #messageBrowser {
      background-color: var(--nixporn-bg) !important;
      color: var(--nixporn-fg) !important;
    }

    toolbar,
    toolbox,
    tree,
    treechildren,
    #folderTree,
    #threadTree {
      background-color: var(--nixporn-bg-alt) !important;
      color: var(--nixporn-fg) !important;
    }

    treechildren::-moz-tree-row(selected),
    treechildren::-moz-tree-row(hover) {
      background-color: var(--nixporn-accent) !important;
    }

    treechildren::-moz-tree-cell-text(selected),
    treechildren::-moz-tree-cell-text(hover) {
      color: var(--nixporn-bg) !important;
    }

    a,
    .text-link {
      color: var(--nixporn-accent) !important;
    }
  '';
in
{
  config = lib.mkIf enable {
    programs.thunderbird = {
      settings = {
        "browser.display.background_color" = ansi.bg;
        "browser.display.foreground_color" = ansi.fg;
        "browser.anchor_color" = ansi.blue;
        "browser.visited_color" = ansi.magenta;
        "mail.theme.content-theme" = if polarity == "light" then 1 else 0;
        "mail.theme.toolbar-theme" = if polarity == "light" then 1 else 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      profiles.default = {
        userChrome = lib.mkBefore css;
        userContent = lib.mkBefore css;
      };
    };
  };
}
