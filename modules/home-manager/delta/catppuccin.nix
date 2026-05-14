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
  target = "delta";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.delta.options.features = "catppuccin-${flavor}";
    programs.git = lib.mkIf config.programs.delta.enableGitIntegration {
      includes = [ { path = "${sources.delta}/catppuccin.gitconfig"; } ];
    };
  };
}
