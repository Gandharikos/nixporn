{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}@moduleArgs:
let
  common = import ../common.nix { inherit colorschemeName; } moduleArgs;
  inherit (common)
    cfg
    colors
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
in
{
  config = mkIf (targetEnabled "btop") {
    programs.btop.settings = {
      color_theme = mkDefault slug;
      theme_background = mkDefault cfg.general.transparent;
    };
    xdg.configFile."btop/themes/${slug}.theme".text = with colors; ''
      theme[main_bg]="${if cfg.general.transparent then "DEFAULT" else bg}"
      theme[main_fg]="${fg}"
      theme[title]="${blue}"
      theme[hi_fg]="${magenta}"
      theme[selected_bg]="${bg_highlight}"
      theme[selected_fg]="${fg}"
      theme[inactive_fg]="${comment}"
      theme[proc_misc]="${cyan}"
      theme[cpu_box]="${blue}"
      theme[mem_box]="${green}"
      theme[net_box]="${magenta}"
      theme[proc_box]="${yellow}"
    '';
  };
}
