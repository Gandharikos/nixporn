{ targetPath }:
{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  target = "squirrel";
  colorscheme = cfg.colorscheme;
  colorschemeCfg = cfg.colorschemes.${colorscheme};
  targetCfg = cfg.${target};
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && targetCfg.enable && !hasSpecific && (config.programs.rime.enable or false);
  inherit (cfg.palette) ansi;

  toRimeColor =
    hex: "0x${builtins.substring 5 2 hex}${builtins.substring 3 2 hex}${builtins.substring 1 2 hex}";

  style = {
    text_color = toRimeColor ansi.fg;
    back_color = toRimeColor ansi.bg;
    border_color = toRimeColor ansi.black;
    label_color = toRimeColor ansi.bright_black;
    candidate_text_color = toRimeColor ansi.fg;
    comment_text_color = toRimeColor ansi.bright_black;
    hilited_text_color = toRimeColor ansi.bg;
    hilited_back_color = toRimeColor ansi.blue;
    hilited_candidate_text_color = toRimeColor ansi.bg;
    hilited_candidate_back_color = toRimeColor ansi.blue;
    hilited_comment_text_color = toRimeColor ansi.black;
  };
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      home.file."${targetCfg.dir}/squirrel.custom.yaml".text = ''
        patch:
          style/color_scheme: ${colorschemeCfg.slug}
          style/color_scheme_dark: ${colorschemeCfg.slug}
          style/font_point: ${toString targetCfg.fontPoint}
          preset_color_schemes/${colorschemeCfg.slug}:
            name: "${colorschemeCfg.slug}"
            author: "nixporn"
            text_color: ${style.text_color}
            back_color: ${style.back_color}
            border_color: ${style.border_color}
            label_color: ${style.label_color}
            candidate_text_color: ${style.candidate_text_color}
            comment_text_color: ${style.comment_text_color}
            hilited_text_color: ${style.hilited_text_color}
            hilited_back_color: ${style.hilited_back_color}
            hilited_candidate_text_color: ${style.hilited_candidate_text_color}
            hilited_candidate_back_color: ${style.hilited_candidate_back_color}
            hilited_comment_text_color: ${style.hilited_comment_text_color}
      '';
    }
  );
}
