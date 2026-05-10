{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.trivial) fromHexString;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  cfg = config.nixporn;
  colors = cfg.colorscheme.palette.base;
  inherit (cfg.colorscheme) slug;

  nixporn =
    lib.nixporn or (import ../../nixporn {
      inherit lib;
    });
  inherit (nixporn.lib) gradient removeHashtag rgba;
  strip = removeHashtag;

  targetEnabled =
    name:
    cfg.enable
    && colors != null
    && cfg.colorscheme.name == colorschemeName
    && cfg.targets.${name}.enable;

  isLight =
    lib.hasInfix "-light" slug
    || lib.hasSuffix "_day" slug
    || lib.hasSuffix "-dawn" slug
    || lib.hasSuffix "-lotus" slug
    || lib.hasInfix "latte" slug;

  hexToRgb =
    color:
    let
      hex = strip color;
      channel = start: builtins.toString ((fromHexString (builtins.substring start 2 hex)) / 255.0);
    in
    concatStringsSep " " [
      (channel 0)
      (channel 2)
      (channel 4)
    ];

  hexToRgba = color: alpha: "${hexToRgb color} ${builtins.toString alpha}";

  terminalPalette = with colors; {
    color0 = black;
    color1 = red;
    color2 = green;
    color3 = yellow;
    color4 = blue;
    color5 = magenta;
    color6 = cyan;
    color7 = white;
    color8 = bright_black;
    color9 = bright_red;
    color10 = bright_green;
    color11 = bright_yellow;
    color12 = bright_blue;
    color13 = bright_magenta;
    color14 = bright_cyan;
    color15 = bright_white;
  };

  tmColorscheme = with colors; ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>name</key><string>${slug}</string>
      <key>settings</key>
      <array>
        <dict>
          <key>settings</key>
          <dict>
            <key>background</key><string>${bg}</string>
            <key>foreground</key><string>${fg}</string>
            <key>caret</key><string>${blue}</string>
            <key>selection</key><string>${bg_visual}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key><string>Comment</string>
          <key>scope</key><string>comment</string>
          <key>settings</key><dict><key>foreground</key><string>${comment}</string></dict>
        </dict>
        <dict>
          <key>name</key><string>Keyword</string>
          <key>scope</key><string>keyword, storage</string>
          <key>settings</key><dict><key>foreground</key><string>${magenta}</string></dict>
        </dict>
        <dict>
          <key>name</key><string>String</string>
          <key>scope</key><string>string</string>
          <key>settings</key><dict><key>foreground</key><string>${green}</string></dict>
        </dict>
        <dict>
          <key>name</key><string>Number</string>
          <key>scope</key><string>constant.numeric, constant.language</string>
          <key>settings</key><dict><key>foreground</key><string>${orange}</string></dict>
        </dict>
        <dict>
          <key>name</key><string>Function</string>
          <key>scope</key><string>entity.name.function, support.function</string>
          <key>settings</key><dict><key>foreground</key><string>${blue}</string></dict>
        </dict>
      </array>
    </dict>
    </plist>
  '';

  materialColors = with colors; {
    primary = blue;
    primaryText = bg;
    primaryContainer = cyan;
    secondary = magenta;
    surface = bg;
    surfaceText = fg;
    surfaceVariant = bg_highlight;
    surfaceVariantText = fg_dark;
    surfaceTint = blue;
    background = bg_dark;
    backgroundText = fg;
    outline = fg_gutter;
    surfaceContainer = bg;
    surfaceContainerHigh = bg_highlight;
    surfaceContainerHighest = bright_black;
    error = red;
    warning = orange;
    info = cyan;
  };

  spicetifyColors = pkgs.writeTextDir "color.ini" (
    with colors;
    ''
      [nixporn]
      text               = ${strip fg}
      subtext            = ${strip fg_dark}
      main               = ${strip bg}
      sidebar            = ${strip bg_dark}
      player             = ${strip bg_dark}
      card               = ${strip bg_highlight}
      shadow             = ${strip black}
      selected-row       = ${strip bg_visual}
      button             = ${strip green}
      button-active      = ${strip bright_green}
      button-disabled    = ${strip comment}
      tab-active         = ${strip bg_highlight}
      notification       = ${strip blue}
      notification-error = ${strip red}
      misc               = ${strip bg_highlight}
    ''
  );
in
{
  inherit
    cfg
    colors
    gradient
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    rgba
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
}
