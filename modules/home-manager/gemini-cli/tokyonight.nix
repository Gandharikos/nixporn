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
  target = "gemini-cli";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
  rawTheme = lib.importJSON "${source}/extras/gemini_cli/${slug}.json";
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
