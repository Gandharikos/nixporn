{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) variant;
  inherit (cfg) palette;
  inherit (palette) ansi;
  accentColor =
    {
      wave = palette.oniViolet;
      dragon = palette.dragonViolet;
      lotus = palette.lotusViolet4;
    }
    .${variant};
  cursorPackage = pkgs.nixporn.kanagawa.cursors.override {
    cursorThemeName = "Vimix-Kanagawa-${variant}-cursors";
    baseColor = accentColor;
    outlineColor = ansi.bg;
    redColor = ansi.red;
    greenColor = ansi.green;
    yellowColor = ansi.yellow;
    blueColor = ansi.blue;
    magentaColor = ansi.magenta;
    cyanColor = ansi.cyan;
    brightRedColor = ansi.bright_red;
    brightGreenColor = ansi.bright_green;
    brightYellowColor = ansi.bright_yellow;
    brightMagentaColor = ansi.bright_magenta;
    brightCyanColor = ansi.bright_cyan;
  };
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.cursors.enable;
in
{
  config = lib.mkIf enable {
    environment.systemPackages = [ cursorPackage ];
    environment.variables.XCURSOR_THEME = cursorPackage.cursorThemeName;
  };
}
