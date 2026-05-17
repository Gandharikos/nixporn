{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) rose-pine;
  inherit (rose-pine) slug;
  sources = pkgs.nixporn.rose-pine;
  target = "lazygit";
  enable = cfg.enable && cfg.colorscheme == "rose-pine" && cfg.${target}.enable;

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
          "${sources.lazygit}/themes/${slug}.yml"
        ]
        ++ lib.optional (config.programs.lazygit.settings != { }) configFile;
      in
      {
        LG_CONFIG_FILE = lib.concatStringsSep "," configFiles;
      };
  };
}
