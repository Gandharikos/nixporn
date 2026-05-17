{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) cyberdream;
  inherit (cyberdream) slug;
  source = pkgs.nixporn.cyberdream;
  target = "lazygit";
  enable = cfg.enable && cfg.colorscheme == "cyberdream" && cfg.${target}.enable;

  enableXdgConfig = !pkgs.stdenv.hostPlatform.isDarwin || config.xdg.enable;
  configDirectory =
    if enableXdgConfig then
      config.xdg.configHome
    else
      "${config.home.homeDirectory}/Library/Application Support";
  configFile = "${configDirectory}/lazygit/config.yml";
in
{
  config = lib.mkIf enable {
    home.sessionVariables =
      let
        configFiles = [
          "${source}/extras/lazygit/${slug}.yml"
        ]
        ++ lib.optional (config.programs.lazygit.settings != { }) configFile;
      in
      {
        LG_CONFIG_FILE = lib.concatStringsSep "," configFiles;
      };
  };
}
