{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "spotify-player";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
  imported = lib.importTOML "${source}/extras/spotify_player/${slug}.toml";
  themes =
    if cfg.transparent then
      map (
        theme: theme // { palette = builtins.removeAttrs theme.palette [ "background" ]; }
      ) imported.themes
    else
      imported.themes;
in
{
  config = lib.mkIf enable {
    programs.spotify-player = {
      settings.theme = (builtins.head themes).name;
      inherit themes;
    };
  };
}
