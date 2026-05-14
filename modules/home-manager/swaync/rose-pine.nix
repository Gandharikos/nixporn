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
  target = "swaync";
  enable =
    cfg.enable
    && cfg.colorscheme == "rose-pine"
    && cfg.${target}.enable
    && config.services.swaync.enable;

  theme = pkgs.substitute {
    src = sources.swaync + "/theme/${slug}.css";
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
