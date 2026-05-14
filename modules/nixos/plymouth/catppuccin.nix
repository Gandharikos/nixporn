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
  target = "plymouth";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themePackage = pkgs.runCommandLocal "catppuccin-${flavor}-plymouth-theme" { } ''
    mkdir -p $out/share/plymouth/themes
    cp -r ${sources.plymouth}/themes/catppuccin-${flavor} $out/share/plymouth/themes/
  '';
in
{
  config = lib.mkIf enable {
    boot.plymouth = {
      theme = "catppuccin-${flavor}";
      themePackages = [ themePackage ];
    };
  };
}
