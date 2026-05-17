{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor slug;
  sources = pkgs.nixporn.catppuccin;
  target = "gemini-cli";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  rawTheme = lib.importJSON "${sources.gemini-cli}/themes/catppuccin-${flavor}.json";
  theme =
    rawTheme
    // {
      name = slug;
      type = "custom";
    }
    // lib.optionalAttrs (rawTheme ? text && builtins.isAttrs rawTheme.text) {
      text = builtins.removeAttrs rawTheme.text [ "response" ];
    };
in
{
  config = lib.mkIf enable {
    programs.gemini-cli.settings.ui = {
      theme = slug;
      customThemes.${slug} = theme;
    };
  };
}
