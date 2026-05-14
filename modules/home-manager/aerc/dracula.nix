{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "aerc";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.aerc = {
      stylesets.dracula = lib.fileContents "${sources.aerc}/dracula";
      extraConfig.ui.styleset-name = "dracula";
    };
  };
}
