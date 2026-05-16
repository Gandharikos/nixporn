{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "spicetify";
  enable =
    cfg.enable
    && cfg.colorscheme == "dracula"
    && cfg.${target}.enable
    && (config.programs.spicetify.enable or false);

  source = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "spicetify";
    rev = "63b2e835d8079d840277defa53651f65deee7d0c";
    hash = "sha256-/5ikaxHIAxODEOJkPKFbA80fxYtPQzN0gXGg7S4RYQA=";
  };
in
{
  config = lib.mkIf enable {
    programs.spicetify = {
      theme = {
        name = "Dracula";
        src = "${source}/Dracula";
      };
      colorScheme = "Base";
    };
  };
}
