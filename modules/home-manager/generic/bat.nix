{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "bat";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = cfg.colorschemes.${colorscheme}.slug;
  themeFile = "${themeName}.tmTheme";
  theme = pkgs.writeTextDir themeFile ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>name</key>
      <string>${themeName}</string>
      <key>settings</key>
      <array>
        <dict>
          <key>settings</key>
          <dict>
            <key>background</key>
            <string>${ansi.bg}</string>
            <key>foreground</key>
            <string>${ansi.fg}</string>
            <key>caret</key>
            <string>${ansi.blue}</string>
            <key>selection</key>
            <string>${ansi.black}</string>
            <key>invisibles</key>
            <string>${ansi.bright_black}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>comment</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.bright_black}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>string</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.green}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>constant.numeric, constant.language, variable.other.constant</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.yellow}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>keyword, storage, entity.name.tag</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.magenta}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>entity.name.function, support.function</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.blue}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>entity.name.type, support.type, variable.parameter</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.cyan}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>invalid, markup.deleted</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.red}</string>
          </dict>
        </dict>
        <dict>
          <key>scope</key>
          <string>markup.inserted</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${ansi.green}</string>
          </dict>
        </dict>
      </array>
    </dict>
    </plist>
  '';
in
{
  config = lib.mkIf enable {
    programs.bat = {
      config.theme = themeName;
      themes.${themeName} = {
        src = theme;
        file = themeFile;
      };
    };
  };
}
