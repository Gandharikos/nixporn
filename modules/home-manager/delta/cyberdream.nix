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
  target = "delta";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.git = lib.mkIf config.programs.delta.enableGitIntegration {
      includes = [ { path = "${source}/extras/delta/${slug}.gitconfig"; } ];
    };
  };
}
