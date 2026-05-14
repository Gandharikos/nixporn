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
  target = "delta";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.git = lib.mkIf config.programs.delta.enableGitIntegration {
      includes = [ { path = "${source}/extras/delta/${slug}.gitconfig"; } ];
    };
  };
}
