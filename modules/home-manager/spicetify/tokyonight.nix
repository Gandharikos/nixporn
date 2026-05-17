{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) style;
  target = "spicetify";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;

  theme = pkgs.fetchFromGitHub {
    owner = "evening-hs";
    repo = "Spotify-Tokyo-Night-Theme";
    rev = "d88ca06eaeeb424d19e0d6f7f8e614e4bce962be";
    hash = "sha256-cLj9v8qtHsdV9FfzV2Qf4pWO8AOBXu51U/lUMvdEXAk=";
  };

  colorScheme =
    if style == "night" then
      "Night"
    else if style == "storm" then
      "Storm"
    else if style == "day" then
      "Light"
    else
      "Night";
in
{
  config = lib.mkIf enable {
    programs.spicetify = {
      theme = {
        name = "Tokyo";
        src = theme;
        overwriteAssets = true;
      };
      inherit colorScheme;
    };
  };
}
