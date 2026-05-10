{
  config,
  lib,
  nixpornSources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources."solarized-osaka";
  cfg = config.nixporn."solarized-osaka";
  targetCfg = config.nixporn.targets."zellij";
  inherit (config.nixporn.colorscheme) slug;
  file = "solarized_osaka_${cfg.variant}";
  enable = cfg.enable && targetCfg.enable && (config.programs.zellij.enable or false);
  theme = builtins.replaceStrings [ "\${_name}" ] [ slug ] (
    builtins.readFile "${src}/extras/zellij/${file}.kdl"
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
