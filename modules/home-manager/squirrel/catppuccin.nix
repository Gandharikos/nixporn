{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) accent flavor palette;
  target = "squirrel";
  targetCfg = cfg.${target};
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && targetCfg.enable;

  slug = "catppuccin-${flavor}-${accent}";
  toRimeColor =
    hex: "0x${builtins.substring 5 2 hex}${builtins.substring 3 2 hex}${builtins.substring 1 2 hex}";
  accentColor = palette.${accent};

  style = {
    text_color = toRimeColor palette.text;
    back_color = toRimeColor palette.base;
    border_color = toRimeColor palette.mantle;
    label_color = toRimeColor palette.overlay1;
    candidate_text_color = toRimeColor palette.text;
    comment_text_color = toRimeColor palette.overlay1;
    hilited_text_color = toRimeColor palette.base;
    hilited_back_color = toRimeColor accentColor;
    hilited_candidate_text_color = toRimeColor palette.base;
    hilited_candidate_back_color = toRimeColor accentColor;
    hilited_comment_text_color = toRimeColor palette.surface2;
  };
in
{
  config = lib.mkIf enable {
    home.file."${targetCfg.dir}/squirrel.custom.yaml".text = ''
      patch:
        style/color_scheme: ${slug}
        style/color_scheme_dark: ${slug}
        style/font_point: ${toString targetCfg.fontPoint}
        preset_color_schemes/${slug}:
          name: "Catppuccin ${flavor} ${accent}"
          author: "catppuccin"
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
  };
}
