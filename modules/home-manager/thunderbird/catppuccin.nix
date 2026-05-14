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
  target = "thunderbird";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.thunderbird.profiles.default.extensions.packages = [
      (pkgs.runCommandLocal "catppuccin-${flavor}-${accent}.thunderbird.theme"
        { nativeBuildInputs = [ pkgs.zip ]; }
        ''
          mkdir -p $out
          cp ${sources.thunderbird}/${flavor}/${flavor}-${accent}.xpi $out/catppuccin-${flavor}-${accent}.xpi
        ''
      )
    ];
  };
}
