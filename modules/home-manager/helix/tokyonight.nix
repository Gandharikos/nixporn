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
  target = "helix";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
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
