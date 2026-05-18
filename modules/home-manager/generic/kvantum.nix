{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "kvantum";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific && config.qt.enable;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;

  kvconfig = pkgs.writeText "${themeName}.kvconfig" (
    lib.generators.toINI { } {
      "%General" = {
        author = "nixporn";
        comment = "Generated from nixporn.palette.ansi";
        composite = true;
        contrast = "1.00";
        intensity = "1.00";
        saturation = "1.00";
        scroll_width = 8;
        tooltip_shadow_depth = 0;
        translucent_windows = false;
      };

      GeneralColors = {
        "window.color" = ansi.bg;
        "base.color" = ansi.bg;
        "alt.base.color" = ansi.black;
        "button.color" = ansi.black;
        "light.color" = ansi.bright_black;
        "mid.light.color" = ansi.bright_black;
        "dark.color" = ansi.bg;
        "mid.color" = ansi.black;
        "highlight.color" = ansi.blue;
        "inactive.highlight.color" = ansi.black;
        "tooltip.base.color" = ansi.black;
        "text.color" = ansi.fg;
        "window.text.color" = ansi.fg;
        "button.text.color" = ansi.fg;
        "disabled.text.color" = ansi.bright_black;
        "tooltip.text.color" = ansi.fg;
        "highlight.text.color" = ansi.bg;
        "link.color" = ansi.blue;
        "link.visited.color" = ansi.magenta;
      };

      PanelButtonCommand = {
        "frame.element" = "button";
        "interior.element" = "button";
        frame = true;
        interior = true;
        "text.normal.color" = ansi.fg;
        "text.focus.color" = ansi.fg;
        "text.press.color" = ansi.fg;
        "text.toggle.color" = ansi.fg;
      };

      PanelButtonTool = {
        inherits = "PanelButtonCommand";
      };

      LineEdit = {
        "frame.element" = "entry";
        "interior.element" = "entry";
        frame = true;
        interior = true;
        "text.normal.color" = ansi.fg;
        "text.focus.color" = ansi.fg;
      };

      ItemView = {
        inherits = "PanelButtonCommand";
        "frame.element" = "itemview";
        "interior.element" = "itemview";
        "text.press.color" = ansi.fg;
        "text.toggle.color" = ansi.fg;
      };

      ToolTip = {
        "frame.top" = 4;
        "frame.right" = 4;
        "frame.bottom" = 4;
        "frame.left" = 4;
        frame = true;
      };

      Focus = {
        "frame.element" = "focus";
        "frame.top" = 1;
        "frame.right" = 1;
        "frame.bottom" = 1;
        "frame.left" = 1;
        frame = true;
      };

      Hacks = {
        transparent_ktitle_label = true;
      };
    }
  );

  svg = pkgs.writeText "${themeName}.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" version="1.1">
      <rect id="common" x="4" y="4" width="24" height="24" rx="3" fill="${ansi.bg}" stroke="${ansi.black}" />
      <rect id="button" x="36" y="4" width="24" height="24" rx="3" fill="${ansi.black}" stroke="${ansi.bright_black}" />
      <rect id="entry" x="4" y="36" width="24" height="24" rx="3" fill="${ansi.bg}" stroke="${ansi.blue}" />
      <rect id="focus" x="36" y="36" width="24" height="24" rx="3" fill="none" stroke="${ansi.blue}" />
      <rect id="itemview" x="4" y="4" width="24" height="24" rx="3" fill="${ansi.black}" stroke="${ansi.black}" />
      <rect id="toolbar" x="36" y="4" width="24" height="24" fill="${ansi.bg}" />
      <rect id="tabframe" x="4" y="36" width="24" height="24" fill="${ansi.bg}" stroke="${ansi.black}" />
    </svg>
  '';

  theme = pkgs.runCommandLocal "${themeName}-kvantum" { } ''
    directory="$out/share/Kvantum/${themeName}"
    mkdir -p "$directory"
    cp ${kvconfig} "$directory/${themeName}.kvconfig"
    cp ${svg} "$directory/${themeName}.svg"
  '';
in
{
  config = lib.mkIf enable {
    xdg.configFile = {
      "Kvantum/${themeName}".source = "${theme}/share/Kvantum/${themeName}";
      "Kvantum/kvantum.kvconfig" = lib.mkIf cfg.${target}.apply {
        text = ''
          [General]
          theme=${themeName}
        '';
      };
    };
  };
}
