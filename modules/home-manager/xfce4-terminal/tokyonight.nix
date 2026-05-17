{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "xfce4-terminal";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
  themeFile = "${source}/extras/xfceterm/${slug}.theme";
  importINI =
    path:
    lib.importJSON (
      pkgs.runCommand "tokyonight-xfce4-terminal-theme.json" { nativeBuildInputs = [ pkgs.jc ]; } ''
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
