{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) polarity slug variant;
  colors = import ../generic/kanagawa-colors.nix {
    inherit (cfg) palette;
    inherit variant;
  };
  target = "fcitx5";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  alpha = color: "${color}00";
  classicUiFile = (pkgs.formats.iniWithGlobalSection { }).generate "fcitx5-classicui.conf" {
    globalSection = {
      Theme = slug;
      DarkTheme = slug;
      Font = "Sans 13";
      MenuFont = "Sans 10";
      TrayFont = "Sans 10";
      UseDarkTheme = polarity == "dark";
      UseAccentColor = false;
    };
  };
  themeFile = (pkgs.formats.ini { }).generate "fcitx5-${slug}-theme.conf" {
    Metadata = {
      Name = slug;
      Version = 0.1;
      Author = "nixporn";
      Description = "Kanagawa fcitx5 theme";
      ScaleWithDPI = true;
    };
    InputPanel = {
      NormalColor = colors.fg;
      HighlightCandidateColor = colors.bg;
      HighlightColor = colors.keyword;
      HighlightBackgroundColor = colors.bgMuted;
      Spacing = 3;
    };
    "InputPanel/Background" = {
      Color = colors.bg;
      BorderColor = colors.bgMuted;
      BorderWidth = 0;
    };
    "InputPanel/Background/Margin" = {
      Left = 10;
      Right = 10;
      Top = 10;
      Bottom = 10;
    };
    "InputPanel/Highlight" = {
      Color = colors.keyword;
      BorderColor = alpha colors.keyword;
      BorderWidth = 0;
    };
    "InputPanel/Highlight/Margin" = {
      Left = 18;
      Right = 18;
      Top = 8;
      Bottom = 8;
    };
    "InputPanel/TextMargin" = {
      Left = 18;
      Right = 18;
      Top = 8;
      Bottom = 8;
    };
    Menu = {
      NormalColor = colors.fg;
      HighlightCandidateColor = colors.bg;
      Spacing = 3;
    };
    "Menu/Background" = {
      Color = colors.bg;
      BorderColor = alpha colors.bgMuted;
      BorderWidth = 0;
    };
    "Menu/Background/Margin" = {
      Left = 2;
      Right = 2;
      Top = 2;
      Bottom = 2;
    };
    "Menu/ContentMargin" = {
      Left = 2;
      Right = 2;
      Top = 2;
      Bottom = 2;
    };
    "Menu/Highlight" = {
      Color = colors.keyword;
      BorderColor = alpha colors.keyword;
      BorderWidth = 0;
    };
    "Menu/Highlight/Margin" = {
      Left = 10;
      Right = 10;
      Top = 5;
      Bottom = 5;
    };
    "Menu/Separator" = {
      Color = colors.bgMuted;
      BorderColor = alpha colors.bgMuted;
      BorderWidth = 0;
    };
  };
in
{
  config = lib.mkIf enable {
    xdg.configFile = lib.mkIf cfg.${target}.apply {
      "fcitx5/conf/classicui.conf".source = classicUiFile;
    };
    xdg.dataFile."fcitx5/themes/${slug}/theme.conf".source = themeFile;
  };
}
