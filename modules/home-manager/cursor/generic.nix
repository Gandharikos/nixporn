{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../common.nix { inherit colorschemeName; } { inherit config lib pkgs; })
    colors
    isLinux
    mkIf
    slug
    targetEnabled
    ;

  palette = config.nixporn.colorscheme.palette;
  cursorColors =
    if palette ? cursor && builtins.isAttrs palette.cursor then
      palette.cursor
    else
      {
        baseColor = colors.blue;
        outlineColor = colors.bg_highlight;
        watchBackgroundColor = colors.orange;
      };

  cursorThemeName = "Bibata-${slug}";
  hyprcursorThemeName = "${cursorThemeName}-Hyprcursor";

  xcursorPackage = import ../../../packages/bibata-xcursor.nix (
    {
      inherit (pkgs)
        clickgen
        fetchFromGitHub
        lib
        resvg
        stdenvNoCC
        ;
      inherit cursorThemeName;
    }
    // cursorColors
  );

  hyprcursorPackage = import ../../../packages/bibata-hyprcursor.nix (
    {
      inherit (pkgs)
        fetchFromGitHub
        hyprcursor
        lib
        python3
        stdenvNoCC
        ;
      inherit (pkgs) python3Packages;
      cursorThemeName = hyprcursorThemeName;
    }
    // cursorColors
  );
in
{
  config = mkIf (targetEnabled "cursor" && isLinux) {
    home.pointerCursor = {
      name = cursorThemeName;
      package = xcursorPackage;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    home.packages = [
      hyprcursorPackage
    ];

    home.sessionVariables = {
      XCURSOR_THEME = cursorThemeName;
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = hyprcursorThemeName;
      HYPRCURSOR_SIZE = "24";
    };
  };
}
