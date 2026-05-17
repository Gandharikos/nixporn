{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "btop";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
in
{
  config = lib.mkIf enable {
    xdg.configFile."btop/themes/${themeName}.theme".text = ''
      theme[main_bg]="${ansi.bg}"
      theme[main_fg]="${ansi.fg}"
      theme[title]="${ansi.blue}"
      theme[hi_fg]="${ansi.cyan}"
      theme[selected_bg]="${ansi.black}"
      theme[selected_fg]="${ansi.bright_white}"
      theme[inactive_fg]="${ansi.bright_black}"
      theme[graph_text]="${ansi.fg}"
      theme[meter_bg]="${ansi.black}"
      theme[proc_misc]="${ansi.magenta}"
      theme[cpu_box]="${ansi.blue}"
      theme[mem_box]="${ansi.green}"
      theme[net_box]="${ansi.cyan}"
      theme[proc_box]="${ansi.yellow}"
      theme[div_line]="${ansi.bright_black}"
      theme[temp_start]="${ansi.green}"
      theme[temp_mid]="${ansi.yellow}"
      theme[temp_end]="${ansi.red}"
      theme[cpu_start]="${ansi.green}"
      theme[cpu_mid]="${ansi.yellow}"
      theme[cpu_end]="${ansi.red}"
      theme[free_start]="${ansi.green}"
      theme[free_mid]="${ansi.yellow}"
      theme[free_end]="${ansi.red}"
      theme[cached_start]="${ansi.cyan}"
      theme[cached_mid]="${ansi.blue}"
      theme[cached_end]="${ansi.magenta}"
      theme[available_start]="${ansi.green}"
      theme[available_mid]="${ansi.yellow}"
      theme[available_end]="${ansi.red}"
      theme[used_start]="${ansi.green}"
      theme[used_mid]="${ansi.yellow}"
      theme[used_end]="${ansi.red}"
      theme[download_start]="${ansi.cyan}"
      theme[download_mid]="${ansi.blue}"
      theme[download_end]="${ansi.magenta}"
      theme[upload_start]="${ansi.green}"
      theme[upload_mid]="${ansi.yellow}"
      theme[upload_end]="${ansi.red}"
    '';
    programs.btop.settings = {
      color_theme = themeName;
      theme_background = !cfg.transparent;
    };
  };
}
