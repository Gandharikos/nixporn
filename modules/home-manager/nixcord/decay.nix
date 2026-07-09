{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.decay;
  nixcord = import ./_helpers/theme.nix { inherit lib; };
  target = "nixcord";
  hasNixcord = options ? programs && options.programs ? nixcord;
  enable =
    cfg.enable
    && cfg.colorscheme == "decay"
    && cfg.${target}.enable
    && (config.programs.nixcord.enable or false);
  themeName = "decay.theme.css";
in
{
  config = lib.optionalAttrs hasNixcord (
    lib.mkIf enable {
      programs.nixcord.config = nixcord.settingsFor cfg themeName;

      home.file."${config.programs.nixcord.configDir}/themes/${themeName}".text =
        nixcord.withTransparentCss cfg (lib.fileContents "${sources.discord}/Decay.theme.css");
    }
  );
}
