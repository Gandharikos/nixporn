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
  target = "tmux";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.tmux.extraConfig = lib.mkBefore ''
      source-file ${source}/extras/tmux/${slug}.tmux
      set -g status-position ${cfg.${target}.statusPosition}
      ${cfg.${target}.extraConfig}
    '';
  };
}
