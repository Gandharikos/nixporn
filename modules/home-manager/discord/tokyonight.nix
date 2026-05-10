{
  lib,
  nixpornSources,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  src = nixpornSources.tokyonight;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."discord";
  enable = cfg.enable && targetCfg.enable && (config.programs.nixcord.enable or false);
  inherit (config.nixporn.general) transparent;
  inherit (config.nixporn.colorscheme) slug;
  discordTheme = builtins.replaceStrings [ "\${pink}" ] [ "var(--guild-boosting-pink)" ] (
    builtins.readFile "${src}/extras/discord/${slug}.css"
  );
in
{
  config = mkIf enable {
    programs.nixcord.config = {
      inherit transparent;
      frameless = true;
      enabledThemes = [
        "${slug}.css"
      ];
    };

    home.file."${config.programs.nixcord.configDir}/themes/${slug}.css".text = discordTheme;
  };
}
