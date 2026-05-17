{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "nushell";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable {
    programs.nushell.extraConfig = lib.mkBefore ''
      $env.config.color_config = {
        separator: "${ansi.bright_black}"
        leading_trailing_space_bg: "${ansi.bright_black}"
        header: "${ansi.green}"
        date: "${ansi.magenta}"
        filesize: "${ansi.blue}"
        row_index: "${ansi.cyan}"
        bool: "${ansi.red}"
        int: "${ansi.green}"
        duration: "${ansi.red}"
        range: "${ansi.red}"
        float: "${ansi.red}"
        string: "${ansi.green}"
        nothing: "${ansi.red}"
        binary: "${ansi.red}"
        cellpath: "${ansi.red}"
        hints: dark_gray
        shape_garbage: { fg: "${ansi.bright_white}" bg: "${ansi.red}" }
        shape_bool: "${ansi.blue}"
        shape_int: { fg: "${ansi.magenta}" attr: b }
        shape_float: { fg: "${ansi.magenta}" attr: b }
        shape_range: { fg: "${ansi.yellow}" attr: b }
        shape_internalcall: { fg: "${ansi.cyan}" attr: b }
        shape_external: "${ansi.cyan}"
        shape_externalarg: { fg: "${ansi.green}" attr: b }
        shape_literal: "${ansi.blue}"
        shape_operator: "${ansi.yellow}"
        shape_signature: { fg: "${ansi.green}" attr: b }
        shape_string: "${ansi.green}"
        shape_filepath: "${ansi.blue}"
        shape_globpattern: { fg: "${ansi.blue}" attr: b }
        shape_variable: "${ansi.magenta}"
        shape_flag: { fg: "${ansi.blue}" attr: b }
        shape_custom: { attr: b }
      }
    '';
  };
}
