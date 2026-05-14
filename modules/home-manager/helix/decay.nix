{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) decay;
  sources = pkgs.nixporn.decay;
  target = "helix";
  enable =
    cfg.enable && cfg.colorscheme == "decay" && cfg.${target}.enable && decay.variant == "dark";
in
{
  config = lib.mkIf enable {
    programs.helix.settings = {
      theme = "darkdecay";
      editor.color-modes = lib.mkDefault true;
    };
    xdg.configFile."helix/themes/darkdecay.toml".source = "${sources.helix}/themes/darkdecay.toml";
  };
}
