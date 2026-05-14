{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "kvantum";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  themeName = "${slug}-rose";
  theme = pkgs.runCommandLocal "rose-pine-kvantum-${themeName}" { } ''
    mkdir -p $out
    tar -xzf ${sources.kvantum}/dist/${themeName}.tar.gz -C $out
  '';
in
{
  config = lib.mkIf enable {
    xdg.configFile."Kvantum/${themeName}".source = "${theme}/${themeName}";
    xdg.configFile."Kvantum/kvantum.kvconfig" = lib.mkIf cfg.${target}.apply {
      text = ''
        [General]
        theme=${themeName}
      '';
    };
  };
}
