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
  target = "helix";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.helix.settings = {
      theme = slug;
      editor.color-modes = lib.mkDefault true;
    };
    xdg.configFile."helix/themes/${slug}.toml".source = "${source}/extras/helix/${slug}.toml";
  };
}
