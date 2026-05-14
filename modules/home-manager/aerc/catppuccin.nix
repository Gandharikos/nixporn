{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) slug;
  sources = pkgs.nixporn.catppuccin;
  target = "aerc";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.aerc = {
      stylesets.${slug} = lib.fileContents "${sources.aerc}/dist/${slug}";
      extraConfig.ui = {
        styleset-name = slug;
        border-char-vertical = "│";
        border-char-horizontal = "─";
      };
    };
  };
}
