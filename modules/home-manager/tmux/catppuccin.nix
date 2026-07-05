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
  plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable";
    src = sources.tmux;
  };
in
{
  config = lib.mkIf enable {
    programs.tmux.plugins = [
      {
        inherit plugin;
        extraConfig = ''
          set -g @catppuccin_flavor "${flavor}"
          ${cfg.${target}.extraConfig}
        '';
      }
    ];
  };
}
