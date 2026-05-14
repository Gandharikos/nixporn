{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) cyberdream;
  inherit (cyberdream) polarity slug;
  source = pkgs.nixporn.cyberdream;
  target = "zed-editor";
  enable =
    cfg.enable
    && cfg.colorscheme == "cyberdream"
    && cfg.${target}.enable
    && config.programs.zed-editor.enable;
in
{
  config = lib.mkIf enable {
    programs.zed-editor.userSettings.theme = {
      mode = polarity;
      light = "Cyberdream";
      dark = "Cyberdream";
    };

    xdg.configFile."zed/themes/cyberdream.json".source = "${source}/extras/zed/${slug}.json";
  };
}
