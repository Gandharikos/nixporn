{ config, lib, ... }:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) slug variant;
  colors = import ../generic/kanagawa-colors.nix {
    inherit (cfg) palette;
    inherit variant;
  };
  target = "micro";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  default = ''"${colors.fg}'' + lib.optionalString (!cfg.micro.transparent) ",${colors.bg}" + ''"'';
  theme = ''
    color-link default ${default}
    color-link comment "${colors.comment}"

    color-link identifier "${colors.namespace}"
    color-link identifier.class "${colors.type}"
    color-link identifier.var "${colors.namespace}"

    color-link constant "${colors.constant}"
    color-link constant.number "${colors.number}"
    color-link constant.string "${colors.string}"

    color-link symbol "${colors.special}"
    color-link symbol.brackets "${colors.punctuation}"
    color-link symbol.tag "${colors.special}"

    color-link type "${colors.type}"
    color-link type.keyword "${colors.type}"

    color-link special "${colors.special}"
    color-link statement "${colors.keyword}"
    color-link preproc "${colors.builtin}"

    color-link underlined "${colors.special}"
    color-link error "bold ${colors.error}"
    color-link todo "bold ${colors.warning}"

    color-link diff-added "${colors.diffAdded}"
    color-link diff-modified "${colors.diffChanged}"
    color-link diff-deleted "${colors.diffDeleted}"

    color-link gutter-error "${colors.error}"
    color-link gutter-warning "${colors.warning}"

    color-link statusline "${colors.fgMuted},${colors.bgDark}"
    color-link tabbar "${colors.fgMuted},${colors.bgDark}"
    color-link indent-char "${colors.gutter}"
    color-link line-number "${colors.gutter}"
    color-link current-line-number "${colors.warning}"

    color-link cursor-line "${colors.bgHighlight},${colors.fg}"
    color-link color-column "${colors.bgMuted}"
    color-link type.extended "default"
  '';
in
{
  # Ported from https://github.com/rebelot/kanagawa.nvim/pull/307.
  config = lib.mkIf enable {
    programs.micro.settings.colorscheme = slug;
    xdg.configFile."micro/colorschemes/${slug}.micro".text = theme;
  };
}
