{
  lib,
  nixpornSources,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."wezterm";
  inherit (config.nixporn.colorscheme) slug;
  enable = cfg.enable && targetCfg.enable && config.programs.wezterm.enable;
in
{
  config = mkIf enable {
    xdg.configFile."wezterm/theme.lua".text = ''
      local wezterm = require("wezterm")

      local M = {}

      ---@param config Config
      function M.setup(config)
        config.color_scheme_dirs = { "${src}/extras/wezterm" }
        config.color_scheme = "${slug}"
        wezterm.add_to_config_reload_watch_list(config.color_scheme_dirs[1] .. config.color_scheme .. ".toml")
      end

      return M
    '';
  };
}
