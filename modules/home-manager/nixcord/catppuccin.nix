{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor;
  nixcord = import ./_helpers/theme.nix { inherit lib; };
  source = pkgs.nixporn.catppuccin.discord;
  target = "nixcord";
  hasNixcord = options ? programs && options.programs ? nixcord;
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && (config.programs.nixcord.enable or false);
  themeName = "catppuccin-${flavor}-${accent}.theme.css";
in
{
  config = lib.optionalAttrs hasNixcord (
    lib.mkIf enable {
      programs.nixcord.config = nixcord.settingsFor cfg themeName;

      home.file."${config.programs.nixcord.configDir}/themes/${themeName}".text =
        nixcord.withTransparentCss cfg (lib.fileContents "${source}/dist/${themeName}");
    }
  );
}
