{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "yazi";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  mkFg = fg: { inherit fg; };
  mkBg = bg: { inherit bg; };
  mkBoth = fg: bg: { inherit fg bg; };
  mkSame = color: mkBoth color color;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      programs.yazi.theme = {
        mgr = {
          cwd = mkFg ansi.cyan;
          find_keyword = (mkFg ansi.green) // {
            bold = true;
          };
          find_position = mkFg ansi.magenta;
          marker_selected = mkSame ansi.yellow;
          marker_copied = mkSame ansi.green;
          marker_cut = mkSame ansi.red;
          border_style = mkFg ansi.bright_black;
          count_copied = mkBoth ansi.bg ansi.green;
          count_cut = mkBoth ansi.bg ansi.red;
          count_selected = mkBoth ansi.bg ansi.yellow;
        };
        tabs = {
          active = (mkBoth ansi.bg ansi.blue) // {
            bold = true;
          };
          inactive = mkBoth ansi.blue ansi.black;
        };
        mode = {
          normal_main = (mkBoth ansi.bg ansi.blue) // {
            bold = true;
          };
          normal_alt = mkBoth ansi.blue ansi.bg;
          select_main = (mkBoth ansi.bg ansi.green) // {
            bold = true;
          };
          select_alt = mkBoth ansi.green ansi.bg;
          unset_main = (mkBoth ansi.bg ansi.yellow) // {
            bold = true;
          };
          unset_alt = mkBoth ansi.yellow ansi.bg;
        };
        status = {
          progress_label = mkBoth ansi.fg ansi.bg;
          progress_normal = mkBoth ansi.fg ansi.bg;
          progress_error = mkBoth ansi.red ansi.bg;
          perm_type = mkFg ansi.blue;
          perm_read = mkFg ansi.yellow;
          perm_write = mkFg ansi.red;
          perm_exec = mkFg ansi.green;
          perm_sep = mkFg ansi.cyan;
        };
        input = {
          border = mkFg ansi.blue;
          title = mkFg ansi.fg;
          value = mkFg ansi.fg;
          selected = mkBg ansi.bright_black;
        };
        filetype.rules = [
          {
            mime = "image/*";
            fg = ansi.cyan;
          }
          {
            mime = "video/*";
            fg = ansi.yellow;
          }
          {
            mime = "audio/*";
            fg = ansi.yellow;
          }
          {
            mime = "application/*zip";
            fg = ansi.magenta;
          }
          {
            mime = "application/pdf";
            fg = ansi.green;
          }
          {
            url = "*/";
            fg = ansi.blue;
            bold = true;
          }
          {
            mime = "*";
            fg = ansi.fg;
          }
        ];
      };
    }
  );
}
