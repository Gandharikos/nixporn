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
  target = "tmux";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.tmux.plugins = [
      {
        plugin = sources.tmux;
        extraConfig = ''
          set -g @catppuccin_flavor "${flavor}"
          ${cfg.${target}.extraConfig}
        '';
      }
    ];
  };
}
