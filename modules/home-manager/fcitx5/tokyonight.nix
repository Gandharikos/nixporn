{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) tokyonight;
  inherit (tokyonight) palette style;
  target = "fcitx5";
  styleName =
    {
      day = "Day";
      moon = "Moon";
      night = "Night";
      storm = "Storm";
    }
    .${style};
  themeName = "Tokyonight-${styleName}";
  alpha = color: "${color}00";
  enable = cfg.enable && cfg.colorscheme == "tokyonight" && cfg.${target}.enable;
  iniFormat = pkgs.formats.ini { };
  iniGlobalFormat = pkgs.formats.iniWithGlobalSection { };
  classicUiFile = iniGlobalFormat.generate "fcitx5-classicui.conf" {
    globalSection = {
      Theme = themeName;
      DarkTheme = themeName;
      Font = "LXGW WenKai 13";
      MenuFont = "LXGW WenKai 10";
      TrayFont = "LXGW WenKai 10";
      UseDarkTheme = style != "day";
      UseAccentColor = false;
    };
  };
  themeFile = iniFormat.generate "fcitx5-${themeName}-theme.conf" {
    Metadata = {
      Name = themeName;
      Version = 0.1;
      Author = "Johnson Hu";
      Description = "Tokyo Night fcitx5 theme (Catppuccin-style layout)";
      ScaleWithDPI = true;
    };
    InputPanel = {
      NormalColor = palette.fg;
      HighlightCandidateColor = palette.bg;
      HighlightColor = palette.blue;
      HighlightBackgroundColor = palette.bg_highlight;
      Spacing = 3;
    };
    "InputPanel/Background" = {
      Color = palette.bg;
      BorderColor = palette.bg_highlight;
      BorderWidth = 0;
    };
    "InputPanel/Background/Margin" = {
      Left = 10;
      Right = 10;
      Top = 10;
      Bottom = 10;
    };
    "InputPanel/Highlight" = {
      Color = palette.blue;
      BorderColor = alpha palette.blue;
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
      NormalColor = palette.fg;
      HighlightCandidateColor = palette.bg;
      Spacing = 3;
    };
    "Menu/Background" = {
      Color = palette.bg;
      BorderColor = alpha palette.bg_highlight;
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
      Color = palette.blue;
      BorderColor = alpha palette.blue;
      BorderWidth = 0;
    };
    "Menu/Highlight/Margin" = {
      Left = 10;
      Right = 10;
      Top = 5;
      Bottom = 5;
    };
    "Menu/Separator" = {
      Color = palette.bg_highlight;
      BorderColor = alpha palette.bg_highlight;
      BorderWidth = 0;
    };
  };
in
{
  config = lib.mkIf enable {
    xdg.configFile = lib.mkIf cfg.${target}.apply {
      "fcitx5/conf/classicui.conf".source = classicUiFile;
    };
    xdg.dataFile."fcitx5/themes/${themeName}/theme.conf".source = themeFile;
  };
}
