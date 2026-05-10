{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.nixporn.tokyonight;
  targetCfg = config.nixporn.targets."squirrel";
  inherit (config.nixporn.colorscheme) palette;

  # Convert #RRGGBB to 0xBBGGRR
  toRimeColor =
    hex: "0x${builtins.substring 5 2 hex}${builtins.substring 3 2 hex}${builtins.substring 1 2 hex}";

  style = {
    text_color = toRimeColor palette.base.fg;
    back_color = toRimeColor palette.base.bg;
    border_color = toRimeColor palette.base.bg_dark;
    label_color = toRimeColor palette.base.comment;
    candidate_text_color = toRimeColor palette.base.fg;
    comment_text_color = toRimeColor palette.base.comment;
    hilited_text_color = toRimeColor palette.base.bg;
    hilited_back_color = toRimeColor palette.base.blue;
    hilited_candidate_text_color = toRimeColor palette.base.bg;
    hilited_candidate_back_color = toRimeColor palette.base.blue;
    hilited_comment_text_color = toRimeColor palette.base.bg_dark;
  };
in
{
  config =
    mkIf
      (
        cfg.enable
        && targetCfg.enable
        && (config.programs.rime.enable or false)
        && pkgs.stdenv.hostPlatform.isDarwin
      )
      {
        home.file."Library/Rime/squirrel.custom.yaml".text = ''
          patch:
            app_options/io.alacritty:
              ascii_mode: true
              no_inline: true
            style/color_scheme: tokyonight
            style/color_scheme_dark: tokyonight
            style/font_point: 18
            preset_color_schemes/tokyonight:
              name: "Tokyo Night"
              author: "folke"
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
