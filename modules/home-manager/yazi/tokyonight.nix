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
  targetCfg = config.nixporn.targets."yazi";
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.yazi = {
      # plugins = {
      #   yatline = pkgs.yaziPlugins.yatline;
      # };
      # initLua = ''
      #   local tokyo_night_theme = require("yatline-tokyo-night"):setup("${cfg.variant}") -- or moon/storm/day
      #   require("yatline"):setup({
      #     theme = tokyo_night_theme
      #   })
      # '';
      theme = {
        "$scheme" = "https://yazi-rs.github.io/schemas/theme.json";
        flavor.use = slug;
      };
    };
    xdg.configFile."yazi/flavors/${slug}.yazi/flavor.toml" = mkIf config.programs.yazi.enable {
      source = "${src}/extras/yazi/${slug}.toml";
    };
  };
}
