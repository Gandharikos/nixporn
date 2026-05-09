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
  targetCfg = config.nixporn.targets."fish";
  enable = cfg.enable && targetCfg.enable && (config.programs.fish.enable or false);
  inherit (config.nixporn.colorscheme) slug;
in
{
  config = mkIf enable {
    # Install modern fish theme format (fish 3.4.0+)
    xdg.configFile."fish/themes/${slug}.theme".source = "${src}/extras/fish_themes/${slug}.theme";

    programs.fish.interactiveShellInit = ''
      fish_config theme choose ${slug}
    '';
  };
}
