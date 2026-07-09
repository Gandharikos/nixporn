{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  nixcord = import ./_helpers/theme.nix { inherit lib; };
  source = pkgs.nixporn.tokyonight;
  target = "nixcord";
  hasNixcord = options ? programs && options.programs ? nixcord;
  enable =
    cfg.enable
    && cfg.colorscheme == "tokyonight"
    && cfg.${target}.enable
    && (config.programs.nixcord.enable or false);
  themeName = "${slug}.css";
  themeCss = builtins.replaceStrings [ "\${pink}" ] [ "var(--guild-boosting-pink)" ] (
    lib.fileContents "${source}/extras/discord/${slug}.css"
  );
in
{
  config = lib.optionalAttrs hasNixcord (
    lib.mkIf enable {
      programs.nixcord.config = nixcord.settingsFor cfg themeName;

      home.file."${config.programs.nixcord.configDir}/themes/${themeName}".text =
        nixcord.withTransparentCss cfg themeCss;
    }
  );
}
