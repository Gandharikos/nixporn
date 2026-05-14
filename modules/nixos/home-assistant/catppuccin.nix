{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "home-assistant";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    services.home-assistant.config = {
      frontend.themes = "!include_dir_merge_named ${sources.home-assistant}";

      "automation catppuccin" = {
        alias = "Catppuccin default theme";
        id = "catppuccin_default_theme";
        mode = "single";
        triggers = [
          {
            trigger = "homeassistant";
            event = "start";
          }
        ];
        actions = [
          {
            action = "frontend.set_theme";
            data = {
              name = "Catppuccin ${lib.toSentenceCase flavor} ${lib.toSentenceCase accent}";
              name_dark = "none";
            };
          }
        ];
      };
    };
  };
}
