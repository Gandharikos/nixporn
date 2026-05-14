{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  source = pkgs.nixporn.solarized-osaka;
  target = "tmux";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.tmux.extraConfig = ''
      source-file ${source}/extras/tmux/${slug}.tmux
      ${cfg.${target}.extraConfig}
    '';
  };
}
