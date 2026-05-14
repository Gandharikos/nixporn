{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) slug;
  source = pkgs.nixporn.tokyonight;
  target = "wezterm";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    xdg.configFile."wezterm/colors/${slug}.toml".source = "${source}/extras/wezterm/${slug}.toml";
    programs.wezterm.extraConfig = ''
      config.color_scheme = "${slug}"
    '';
  };
}
