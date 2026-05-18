{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  target = "spicetify";
  hasProgram = options.programs ? spicetify;
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;

  source = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "spicetify";
    rev = "1ec645c4cf7f42f9792b9eeb1bb7930f94593277";
    hash = "sha256-VK9JpXYFuLMkIuMftFkkMy6Y5+ttuxDUYoIiAPlx6YY=";
  };
in
{
  config = lib.optionalAttrs hasProgram (
    lib.mkIf enable {
      programs.spicetify = {
        theme = {
          name = "catppuccin";
          src = "${source}/catppuccin";
          overwriteAssets = true;
        };
        colorScheme = flavor;
      };
    }
  );
}
