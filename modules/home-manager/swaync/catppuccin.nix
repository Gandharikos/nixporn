{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "swaync";
  enable =
    cfg.enable
    && cfg.colorscheme == "catppuccin"
    && cfg.${target}.enable
    && config.services.swaync.enable;

  theme = pkgs.substitute {
    src = sources.swaync + "/${flavor}.css";
    substitutions = [
      "--replace-warn"
      "Ubuntu Nerd Font"
      cfg.${target}.font
      "--replace-warn"
      "font-size: 14px;"
      "font-size: ${cfg.${target}.fontSize}px;"
    ];
  };
in
{
  config = lib.mkIf enable {
    services.swaync.style = theme;

    home.packages = lib.mkIf (cfg.${target}.font == "Ubuntu Nerd Font") [
      pkgs.nerd-fonts.ubuntu
    ];
  };
}
