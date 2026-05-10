{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.cyberdream;
  cfg = config.nixporn.cyberdream;
  targetCfg = config.nixporn.targets."zellij";
  inherit (config.nixporn.colorscheme) slug;
  enable = cfg.enable && targetCfg.enable && (config.programs.zellij.enable or false);
  theme = builtins.replaceStrings [ "    cyberdream {" ] [ "    ${slug} {" ] (
    builtins.readFile "${src}/extras/zellij/${slug}.kdl"
  );
in
{
  config = mkIf enable {
    programs.zellij.settings = {
      theme = slug;
      theme_dir = "${config.xdg.configHome}/zellij/themes";
    };
    xdg.configFile."zellij/themes/${slug}.kdl".text = theme;
  };
}
