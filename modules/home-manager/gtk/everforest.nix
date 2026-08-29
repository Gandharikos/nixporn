{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  polarity = lib.toSentenceCase cfg.colorschemes.everforest.polarity;
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.gtk.enable;
in
{
  config = lib.mkIf enable {
    gtk = {
      theme = {
        name = "Everforest-${polarity}";
        package = pkgs.nixporn.everforest.gtk;
      };

      iconTheme = {
        name = "Everforest-${polarity}";
        package = pkgs.nixporn.everforest.gtk;
      };
    };
  };
}
