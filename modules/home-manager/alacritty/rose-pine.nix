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
  target = "alacritty";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.alacritty.settings.general.import = lib.mkBefore [
      "${sources.alacritty}/dist/${slug}.toml"
    ];
  };
}
