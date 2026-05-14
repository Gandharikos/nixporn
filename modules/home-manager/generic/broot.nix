{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "broot";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = "nixporn-${colorscheme}";
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      xdg.configFile."broot/skins/${themeName}.toml".text = ''
        [skin]
        default = "${ansi.fg} ${ansi.bg}"
        tree = "${ansi.bright_black} none"
        file = "none none"
        directory = "${ansi.blue} none bold"
        exe = "${ansi.red} none"
        link = "${ansi.cyan} none"
        pruning = "${ansi.bright_black} none italic"
        perm__ = "${ansi.bright_black} none"
        git_branch = "${ansi.magenta} none"
        git_insertions = "${ansi.green} none"
        git_deletions = "${ansi.red} none"
        git_status_modified = "${ansi.yellow} none"
        git_status_new = "${ansi.green} none"
        git_status_ignored = "${ansi.bright_black} none"
        selected_line = "none ${ansi.black}"
        char_match = "${ansi.green} none underlined"
        file_error = "${ansi.red} none italic"
        flag_value = "${ansi.yellow} none bold"
        status_error = "${ansi.red} ${ansi.black}"
        status_job = "${ansi.magenta} ${ansi.black} bold"
        status_normal = "none ${ansi.black}"
        status_italic = "${ansi.yellow} ${ansi.black}"
        status_bold = "${ansi.magenta} ${ansi.black} bold"
        help_bold = "${ansi.magenta} none bold"
        help_italic = "${ansi.magenta} none italic"
        help_code = "${ansi.magenta} ${ansi.black}"
        help_headers = "${ansi.yellow} none"
      '';
      programs.broot.settings.imports = [
        {
          file = "skins/${themeName}.toml";
          luma = "light";
        }
        {
          file = "skins/${themeName}.toml";
          luma = [
            "dark"
            "unknown"
          ];
        }
      ];
    }
  );
}
