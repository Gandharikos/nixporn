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
  target = "qutebrowser";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;

  files = {
    "qutebrowser/catppuccin".source = sources.qutebrowser;
  };
in
{
  config = lib.mkIf enable {
    home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      lib.mapAttrs' (name: lib.nameValuePair ("." + name)) files
    );

    xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux files;

    programs.qutebrowser.extraConfig = lib.mkMerge [
      (lib.mkBefore "import catppuccin")
      (lib.mkAfter "catppuccin.setup(c, '${flavor}', False)")
    ];
  };
}
