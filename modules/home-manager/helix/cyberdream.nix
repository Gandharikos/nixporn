{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) cyberdream;
  inherit (cyberdream) slug;
  source = pkgs.nixporn.cyberdream;
  target = "helix";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.helix.settings = {
      theme = slug;
      editor.color-modes = lib.mkDefault true;
    };
    xdg.configFile."helix/themes/${slug}.toml".source = "${source}/extras/helix/${slug}.toml";
  };
}
