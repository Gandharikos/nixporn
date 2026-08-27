{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "tmux";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
  plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "dracula";
    version = "unstable";
    src = sources.tmux;
  };
in
{
  config = lib.mkIf enable {
    programs.tmux.plugins = [
      {
        inherit plugin;
        extraConfig = cfg.${target}.extraConfig;
      }
    ];
  };
}
