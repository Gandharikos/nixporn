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
in
{
  config = lib.mkIf enable {
    programs.tmux.plugins = [
      {
        plugin = sources.tmux;
        extraConfig = cfg.${target}.extraConfig;
      }
    ];
  };
}
