{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."gowall";
  inherit (config.nixporn.colorscheme) palette slug;
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    home = {
      packages = with pkgs; [
        gowall
      ];
      file.".config/gowall/config.yml".text = with palette.base; ''
        themes:
          - name: "${slug}"
            colors:
              - "#${black}"
              - "#${bright_black}"
              - "#${yellow}"
              - "#${green}"
              - "#${bright_yellow}"
              - "#${white}"
              - "#${bright_white}"
              - "#${cyan}"
              - "#${bright_cyan}"
              - "#${blue}"
              - "#${bright_red}"
              - "#${bright_blue}"
              - "#${red}"
              - "#${bright_green}"
              - "#${magenta}"
              - "#${bright_magenta}"
      '';
    };
  };
}
