{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  target = "opencode";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
  themeName =
    if flavor == "frappe" then
      "catppuccin-frappe"
    else if flavor == "macchiato" then
      "catppuccin-macchiato"
    else
      "catppuccin";
in
{
  config = lib.mkIf enable {
    programs.opencode.tui.theme = themeName;
  };
}
