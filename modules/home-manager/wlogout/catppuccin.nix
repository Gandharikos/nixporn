{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "wlogout";
  targetCfg = cfg.${target};
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.wlogout.style = lib.concatStrings [
      ''
        @import url("${sources.wlogout}/themes/${flavor}/${accent}.css");
      ''
      (lib.concatMapStrings
        (icon: ''
          #${icon} {
            background-image: url("${sources.wlogout}/icons/${targetCfg.iconStyle}/${flavor}/${accent}/${icon}.svg");
          }
        '')
        [
          "hibernate"
          "lock"
          "logout"
          "reboot"
          "shutdown"
          "suspend"
        ]
      )
      targetCfg.extraStyle
    ];
  };
}
