{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "bottom";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  graphColors = [
    ansi.red
    ansi.yellow
    ansi.green
    ansi.cyan
    ansi.blue
    ansi.magenta
  ];
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.bottom.settings.styles = {
        cpu = {
          all_entry_color = ansi.fg;
          avg_entry_color = ansi.magenta;
          cpu_core_colors = graphColors;
        };
        memory = {
          ram_color = ansi.green;
          cache_color = ansi.red;
          swap_color = ansi.yellow;
          gpu_colors = graphColors;
          arc_color = ansi.cyan;
        };
        network = {
          rx_color = ansi.green;
          tx_color = ansi.red;
          rx_total_color = ansi.cyan;
          tx_total_color = ansi.green;
        };
        battery = {
          high_battery_color = ansi.green;
          medium_battery_color = ansi.yellow;
          low_battery_color = ansi.red;
        };
        tables.headers.color = ansi.fg;
        graphs = {
          graph_color = ansi.bright_black;
          legend_text.color = ansi.bright_black;
        };
        widgets = {
          border_color = ansi.bright_black;
          selected_border_color = ansi.magenta;
          widget_title.color = ansi.cyan;
          text.color = ansi.fg;
          selected_text = {
            color = ansi.bg;
            bg_color = ansi.magenta;
          };
          disabled_text.color = ansi.black;
        };
      };
    }
  );
}
