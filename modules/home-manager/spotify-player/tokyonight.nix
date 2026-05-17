{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) palette slug;
  inherit (palette) ansi;
  target = "spotify-player";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.spotify-player = {
      settings.theme = slug;
      themes = [
        {
          name = slug;
          palette = {
            background = ansi.bg;
            foreground = ansi.fg;
            black = ansi.black;
            red = ansi.red;
            green = ansi.green;
            yellow = ansi.yellow;
            blue = ansi.blue;
            magenta = ansi.magenta;
            cyan = ansi.cyan;
            white = ansi.white;
            bright_black = ansi.bright_black;
            bright_red = ansi.bright_red;
            bright_green = ansi.bright_green;
            bright_yellow = ansi.bright_yellow;
            bright_blue = ansi.bright_blue;
            bright_magenta = ansi.bright_magenta;
            bright_cyan = ansi.bright_cyan;
            bright_white = ansi.bright_white;
          };
          component_style = {
            block_title = {
              fg = "BrightGreen";
              modifiers = [
                "Italic"
                "Bold"
              ];
            };
            border.fg = "BrightYellow";
            current_playing = {
              fg = "Red";
              modifiers = [
                "Bold"
                "Italic"
              ];
            };
            like = {
              fg = "Red";
              modifiers = [ "Bold" ];
            };
            page_desc = {
              fg = "Magenta";
              modifiers = [
                "Bold"
                "Italic"
              ];
            };
            playback_album = {
              fg = "BrightRed";
              modifiers = [ "Italic" ];
            };
            playback_artists = {
              fg = "BrightCyan";
              modifiers = [ ];
            };
            playback_metadata = {
              fg = "BrightBlue";
              modifiers = [ ];
            };
            playback_progress_bar = {
              fg = "BrightGreen";
              modifiers = [ "Italic" ];
            };
            playback_track = {
              fg = "BrightMagenta";
              modifiers = [ "Italic" ];
            };
            playlist_desc = {
              fg = "White";
              modifiers = [ "Italic" ];
            };
            secondary_row.bg = "BrightBlack";
            selection = {
              fg = "Red";
              modifiers = [
                "Bold"
                "Reversed"
              ];
            };
            table_header = {
              fg = "Blue";
              modifiers = [ "Bold" ];
            };
          };
        }
      ];
    };
  };
}
