{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources."solarized-osaka";
  cfg = config.nixporn."solarized-osaka";
  targetCfg = config.nixporn.targets."fish";
  inherit (config.nixporn.colorscheme) slug;
  file = "solarized_osaka_${cfg.variant}";
  enable = cfg.enable && targetCfg.enable && (config.programs.fish.enable or false);
in
{
  config = mkIf enable {
    xdg.configFile."fish/themes/${slug}.theme".source = "${src}/extras/fish_themes/${file}.theme";
    programs.fish.interactiveShellInit = ''
      fish_config theme choose ${slug}
    '';
  };
}
