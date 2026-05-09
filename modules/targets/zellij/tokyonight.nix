{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixporn.colorscheme) palette slug;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."zellij";
  enable = cfg.enable && targetCfg.enable && (config.programs.zellij.enable or false);
in
{
  config = mkIf enable {
    programs.zellij = {
      settings = {
        theme = slug;
        theme_dir = "${config.xdg.configHome}/zellij/themes";
      };
      themes.${slug} = with palette; {
        themes.${slug} = {
          inherit
            blue
            cyan
            fg
            green
            magenta
            orange
            red
            white
            yellow
            ;
          bg = bg_highlight;
          black = bg;
        };
      };
    };
  };
}
