{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "qutebrowser";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;

  files = {
    "qutebrowser/dracula".source = sources.qutebrowser;
  };
in
{
  config = lib.mkIf enable {
    home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      lib.mapAttrs' (name: lib.nameValuePair ("." + name)) files
    );

    xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux files;

    programs.qutebrowser.extraConfig = lib.mkMerge [
      (lib.mkBefore "import dracula.draw")
      (lib.mkAfter ''
        dracula.draw.blood(c, {
            'spacing': {
                'vertical': 6,
                'horizontal': 8
            }
        })
      '')
    ];
  };
}
