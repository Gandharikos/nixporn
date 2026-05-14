{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "helix";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;
  themeName = lib.replaceStrings [ "-" ] [ "_" ] slug;
in
{
  config = lib.mkIf enable {
    programs.helix.settings = {
      theme = themeName;
      editor.color-modes = lib.mkDefault true;
    };
    xdg.configFile."helix/themes/${themeName}.toml".source = "${sources.helix}/${themeName}.toml";
  };
}
