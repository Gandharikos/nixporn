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
  target = "fish";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."fish/themes/${slug}.theme".source = "${source}/extras/fish_themes/${slug}.theme";
    programs.fish.shellInit = ''
      fish_config theme choose "${slug}"
    '';
  };
}
