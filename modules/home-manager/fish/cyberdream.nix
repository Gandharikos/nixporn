{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.cyberdream;
  cfg = config.nixporn.cyberdream;
  targetCfg = config.nixporn.targets."fish";
  inherit (config.nixporn.colorscheme) slug;
  enable = cfg.enable && targetCfg.enable && (config.programs.fish.enable or false);
in
{
  config = mkIf enable {
    xdg.configFile."fish/themes/${slug}.theme".source = "${src}/extras/fish/${slug}.theme";
    programs.fish.interactiveShellInit = ''
      fish_config theme choose ${slug}
    '';
  };
}
