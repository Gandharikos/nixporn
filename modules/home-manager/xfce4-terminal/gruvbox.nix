{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.gruvbox) variant;
  sources = pkgs.nixporn.gruvbox;
  target = "xfce4-terminal";
  enable = cfg.enable && cfg.colorscheme == "gruvbox" && cfg.${target}.enable;
  themeFile = "gruvbox-${variant}.theme";
  importINI =
    path:
    lib.importJSON (
      pkgs.runCommand "gruvbox-xfce4-terminal-theme.json" { nativeBuildInputs = [ pkgs.jc ]; } ''
        jc --ini < ${path} > $out
      ''
    );
in
{
  config = lib.mkIf enable {
    programs.xfconf.settings.xfce4-terminal =
      lib.mapAttrs' (name: value: lib.nameValuePair "color-${lib.toLower name}" value)
        (
          builtins.removeAttrs (importINI "${sources.contrib}/xfce4-terminal/${themeFile}").Scheme [ "Name" ]
        );
  };
}
