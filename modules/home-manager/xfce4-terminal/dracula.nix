{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "xfce4-terminal";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
  importINI =
    path:
    lib.importJSON (
      pkgs.runCommand "dracula-xfce4-terminal-theme.json" { nativeBuildInputs = [ pkgs.jc ]; } ''
        jc --ini < ${path} > $out
      ''
    );
in
{
  config = lib.mkIf enable {
    xfconf.settings.xfce4-terminal = lib.mapAttrs' (
      name: value: lib.nameValuePair "color-${lib.toLower name}" value
    ) (builtins.removeAttrs (importINI "${sources.xfce4-terminal}/Dracula.theme").Scheme [ "Name" ]);
  };
}
