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
  target = "wezterm";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.wezterm.extraConfig = ''
      local catppuccin = dofile("${sources.wezterm}/plugin/init.lua")
      local config = config or {}
      catppuccin.apply_to_config(config, { flavor = "${flavor}" })
      return config
    '';
  };
}
