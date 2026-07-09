{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  nixcord = import ./_helpers/theme.nix { inherit lib; };
  source = pkgs.nixporn.solarized-osaka;
  target = "nixcord";
  hasNixcord = options ? programs && options.programs ? nixcord;
  enable =
    cfg.enable
    && cfg.colorscheme == "solarized-osaka"
    && cfg.${target}.enable
    && (config.programs.nixcord.enable or false);
  themeName = "${slug}.css";
in
{
  config = lib.optionalAttrs hasNixcord (
    lib.mkIf enable {
      programs.nixcord.config = nixcord.settingsFor cfg themeName;

      home.file."${config.programs.nixcord.configDir}/themes/${themeName}".text =
        nixcord.withTransparentCss cfg (lib.fileContents "${source}/extras/discord/${slug}.css");
    }
  );
}
