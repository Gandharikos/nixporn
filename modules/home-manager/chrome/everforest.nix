{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "chrome";
  enable = cfg.enable && cfg.colorscheme == "everforest" && cfg.${target}.enable;
  identifier = "dlcadbmcfambdjhecipbnolmjchgnode";
  supportedBrowsers = [
    "brave"
    "chromium"
    "vivaldi"
  ];
  generateConfig = browser: {
    programs.${browser}.extensions = [ { id = identifier; } ];
  };
in
{
  config = lib.mkIf enable (lib.mkMerge (map generateConfig supportedBrowsers));
}
