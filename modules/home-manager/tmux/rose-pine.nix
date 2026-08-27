{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) variant;
  sources = pkgs.nixporn.rose-pine;
  target = "tmux";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "rose-pine";
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
          set -g @rose_pine_variant "${variant}"
          ${cfg.${target}.extraConfig}
        '';
      }
    ];
  };
}
