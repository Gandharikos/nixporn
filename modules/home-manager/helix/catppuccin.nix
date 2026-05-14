{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "helix";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.helix.settings = {
      theme = "catppuccin-${flavor}";
      editor.color-modes = lib.mkDefault true;
    };
    xdg.configFile."helix/themes/catppuccin-${flavor}.toml".source =
      "${sources.helix}/default/catppuccin_${flavor}.toml";
  };
}
