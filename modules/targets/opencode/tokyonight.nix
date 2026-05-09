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
  targetCfg = config.nixporn.targets."opencode";
  enable = cfg.enable && targetCfg.enable && (config.programs.opencode.enable or false);
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf enable {
    # OpenCode v1.2.15+ requires TUI settings in separate tui section
    programs.opencode.tui.theme = slug;

    xdg.configFile."opencode/themes/${slug}.json".source = "${src}/extras/opencode/${slug}.json";
  };
}
