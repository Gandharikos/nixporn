{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "xfce4-terminal";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeFile = "${sources.xfce4-terminal}/catppuccin-${flavor}.theme";
  importINI =
    path:
    lib.importJSON (
      pkgs.runCommand "catppuccin-xfce4-terminal-theme.json" { nativeBuildInputs = [ pkgs.jc ]; } ''
        jc --ini < ${path} > $out
      ''
    );
in
{
  config = lib.mkIf enable {
    xfconf.settings.xfce4-terminal = lib.mapAttrs' (
      name: value: lib.nameValuePair "color-${lib.toLower name}" value
    ) (builtins.removeAttrs (importINI themeFile).Scheme [ "Name" ]);
  };
}
