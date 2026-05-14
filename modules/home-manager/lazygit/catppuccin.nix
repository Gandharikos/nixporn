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
  target = "lazygit";
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && config.programs.lazygit.enable;

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
          "${sources.lazygit}/themes/${flavor}/${accent}.yml"
        ]
        ++ lib.optional (config.programs.lazygit.settings != { }) configFile;
      in
      {
        LG_CONFIG_FILE = lib.concatStringsSep "," configFiles;
      };
  };
}
