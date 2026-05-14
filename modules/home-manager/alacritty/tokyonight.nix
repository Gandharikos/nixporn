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
  target = "alacritty";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.alacritty.settings.general.import = lib.mkBefore [
      "${source}/extras/alacritty/${slug}.toml"
    ];
  };
}
