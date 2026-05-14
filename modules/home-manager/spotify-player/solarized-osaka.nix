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
  target = "spotify-player";
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
  inherit (lib.importTOML "${source}/extras/spotify_player/${slug}.toml") themes;
in
{
  config = lib.mkIf enable {
    programs.spotify-player = {
      settings.theme = (builtins.head themes).name;
      inherit themes;
    };
  };
}
