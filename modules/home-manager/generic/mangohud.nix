{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "mangohud";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  hex = lib.removePrefix "#";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.mangohud.settings = {
        text_color = hex ansi.fg;
        text_outline_color = hex ansi.bg;
        background_color = hex ansi.bg;
        gpu_color = hex ansi.green;
        cpu_color = hex ansi.blue;
        vram_color = hex ansi.cyan;
        media_player_color = hex ansi.fg;
        engine_color = hex ansi.magenta;
        wine_color = hex ansi.magenta;
        frametime_color = hex ansi.green;
        battery_color = hex ansi.bright_black;
        io_color = hex ansi.yellow;
        gpu_load_color = "${hex ansi.green}, ${hex ansi.yellow}, ${hex ansi.red}";
        cpu_load_color = "${hex ansi.green}, ${hex ansi.yellow}, ${hex ansi.red}";
        fps_color = "${hex ansi.green}, ${hex ansi.yellow}, ${hex ansi.red}";
      };
    }
  );
}
