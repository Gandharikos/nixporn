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
  target = "gtk";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  polarity = lib.toSentenceCase catppuccin.polarity;
  iconPackage = pkgs.catppuccin-papirus-folders.override { inherit accent flavor; };
in
{
  config = lib.mkIf enable {
    services.displayManager.generic.environment.XDG_DATA_DIRS =
      (lib.makeSearchPath "share" [ iconPackage ]) + ":";
    programs.dconf.profiles.gdm.databases = [
      {
        lockAll = true;
        settings."org/gnome/desktop/interface".icon-theme = "Papirus-${polarity}";
      }
    ];
  };
}
