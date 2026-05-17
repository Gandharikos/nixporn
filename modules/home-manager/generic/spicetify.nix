{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "spicetify";
  inherit (cfg) colorscheme;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable =
    cfg.enable && cfg.${target}.enable && !hasSpecific && (config.programs.spicetify.enable or false);
  inherit (cfg.palette) ansi;

  strip = lib.removePrefix "#";
  themeName = "nixporn-${colorschemeCfg.slug}";
  theme = pkgs.symlinkJoin {
    name = "${themeName}-spicetify";
    paths = [
      (pkgs.writeTextDir "color.ini" ''
        [nixporn]
        text               = ${strip ansi.fg}
        subtext            = ${strip ansi.white}
        main               = ${strip ansi.bg}
        sidebar            = ${strip ansi.black}
        player             = ${strip ansi.black}
        card               = ${strip ansi.bright_black}
        shadow             = ${strip ansi.black}
        selected-row       = ${strip ansi.bright_black}
        button             = ${strip ansi.green}
        button-active      = ${strip ansi.bright_green}
        button-disabled    = ${strip ansi.bright_black}
        tab-active         = ${strip ansi.bright_black}
        notification       = ${strip ansi.blue}
        notification-error = ${strip ansi.red}
        misc               = ${strip ansi.bright_black}
      '')
      (pkgs.writeTextDir "user.css" "")
    ];
  };
in
{
  config = lib.mkIf enable {
    programs.spicetify = {
      theme = {
        name = themeName;
        src = theme;
      };
      colorScheme = "nixporn";
    };
  };
}
